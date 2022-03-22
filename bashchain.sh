#!/bin/bash

# how many leading zeros should we match
LEADING_ZEROS=${1:-3}
# generate a match string (eg 000)
NEEDED_ZEROS=$(printf -- '0%.0s' $(seq "${LEADING_ZEROS}"))
# generate an initial uuid
NEXT_HASH=$(uuidgen)
# initialize counter for number of hashes
COUNT=1

# find the latest block file
LATEST_BLOCK_FILE=$(find . -type f -iname "block_*" | sort -n | cut -c 3- | tail -1)
# save hash of the latest block
LATEST_BLOCK_HASH=$(md5sum "$LATEST_BLOCK_FILE" | awk '{print $1}')
# get the number for the next block file
NEXT_BLOCK_NUMBER=${LATEST_BLOCK_FILE%%.*}
NEXT_BLOCK_NUMBER=$((${NEXT_BLOCK_NUMBER#*_}+1))

# colored output
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# main loop
# until the begining of NEXT_HASH matches the number of zeros
until [[ "${NEXT_HASH:0:$LEADING_ZEROS}" == "${NEEDED_ZEROS}" ]]; do
	# generate new seed each iteration
	SEED=$(uuidgen)
	# concat seed with last block hash and save new hash
	NEXT_HASH=$(printf '%s%s' "${SEED}" "${LATEST_BLOCK_HASH}" | md5sum | awk '{print $1}')
	# print seed and hash
	echo "${SEED} : ${NEXT_HASH}"
	# increment hash
	COUNT=$((COUNT+1))
done

# write new block file
echo "${SEED}" > block_${NEXT_BLOCK_NUMBER}
echo "${NEEDED_ZEROS}" >> block_${NEXT_BLOCK_NUMBER}
# output stats
echo "
${GREEN}block_${NEXT_BLOCK_NUMBER}${RESET} written
from seed ${GREEN}${SEED}${RESET}
with hash ${GREEN}${NEXT_HASH}${RESET}
in ${GREEN}${COUNT}${RESET} iterations"
