inherit extrausers

EXTRA_USERS_PARAMS = " \
    usermod -p '\$6\$9sY8XexHzc/UhkMS\$hhVcnvra3Izuc7LH1XTsx1xR23lH3R8J4V3Nl3YzlJaX1zmqlYCznvgcT5Ph95hu1qmsSQkN1H5/tNRxXrdE41' root; \
"

IMAGE_FEATURES += " ssh-server-openssh"

UTILS = " \
    htop \
    nano \
    fastfetch \
    util-linux \
    mtd-utils \
    mtd-utils-ubifs \
    mtd-utils-misc \
"

IMAGE_INSTALL:append = " \
    ${UTILS} \
"
                         