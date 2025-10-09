

# This is a small summary regarding the Luckfox Pico Mini B rv1106 SPI NAND flashing.

## Step 1

Build SDCARD image for Luckfox Pico Mini A and write to sdcard

## Step 2

After building for the Luckfox Pico Mini B, copy the following three files to the SDCARD:
- idbloader.img-luckfox-pico-mini-b-xxxx.yyy-zzz
- u-boot-luckfox-pico-mini-b-xxxx.yy-zz.img
- core-image-base-luckfox-pico-mini-b.rootfs-xxxxxxxxxxxxxx.ubi

The first contains the primary (ddr/tpl) and secondary bootloader (spl), the second contains U-Boot itself, and the third contains the device tree blob (dtb), the kernel (Linux kernel), and the root filesystem.

## Step 3

Connect to the target board's debug UART using a USB-UART converter (the required pins can be found on the [wiki page](https://wiki.luckfox.com/Luckfox-Pico-Plus-Mini/UART)).

## Step 4

Run a program for communication with the serial communication port (for example, minicom) configured for speed 115200 and turn on the board's power.

```
 # minicom -D /dev/ttyUSB0 -b 115200
```

## Step 5

Stop U-Boot startup and, just in case, erase absolutely everything, including the bad block table (maybe not the best idea, but I had reasons when, after incorrectly flashing .ubi, half my flash drive fell into bad blocks) with the following command:

```
 # mtd erase.dontskipbad spi-nand0
```

, then reboot the board.

## Step 6

Login using debug password (for security reasons, you need to change this password in core-image-%.bbappend or after installation with the passwd command)

```
login: root
password: password
```

## Step 6

The mtdparts arguments may not have been passed to the kernel arguments, so it is necessary to manually partition the drive according to the table defined in U-Boot:

```
 # mtdpart add /dev/mtd0 tpl 0x0 0x20000
 [   68.568656] 0x000000000000-0x000000020000 : "tpl"

 # mtdpart add /dev/mtd0 uboot 0x20000 0x100000
 [   71.945703] 0x000000020000-0x000000120000 : "uboot"

 # mtdpart add /dev/mtd0 rootfs 0x120000 0x7ee0000
 [   76.157723] 0x000000120000-0x000008000000 : "rootfs"
```

## Step 7

Format partitions:

```
 # flash_erase /dev/mtd1 0 0
 Erasing 128 Kibyte @ 0 -- 100 % complete 

 # flash_erase /dev/mtd2 0 0
 Erasing 1024 Kibyte @ 0 -- 100 % complete 

 # flash_erase /dev/mtd3 0 0
 Erasing 129920 Kibyte @ 0 -- 100 % complete 
```

## Step 8

Flash build artifacts

```
 # nandwrite -p /dev/mtd1 /path/to/idbloader.img-luckfox-pico-mini-b-xxxx.yyy-zzz
 Writing data to block 0 at offset 0x0

 # nandwrite -p /dev/mtd2 /path/to/u-boot-luckfox-pico-mini-b-xxxx.yy-zz.img
 Writing data to block 0 at offset 0x0
 Writing data to block 1 at offset 0x20000
 Writing data to block 2 at offset 0x40000
 Writing data to block 3 at offset 0x60000
 Writing data to block 4 at offset 0x80000

 # ubiformat /dev/mtd3 -f /path/to/core-image-base-luckfox-pico-mini-b.rootfs-xxxxxxxxxxxxxx.ubi
 ubiformat: mtd3 (nand), size 133038080 bytes (126.8 MiB), 1015 eraseblocks of 131072 bytes (1280 KiB), min. I/O size 2048 bytes
 libscan: scanning eraseblock 1014 -- 100 % complete  
 ubiformat: 1015 eraseblocks are supposedly empty
 ubiformat: flashing eraseblock 233 -- 100 % complete  
 ubiformat: formatting eraseblock 1014 -- 100 % complete
```

## Step 9

Turn off the power, take out the flash drive, turn on the power and enjoy working with SPINAND
