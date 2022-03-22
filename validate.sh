#!/bin/bash

# find the latest block file
LATEST_BLOCK_FILE=$(find . -type f -iname "block_*" | sort -n | cut -c 3- | tail -1)
# get the number for the next block file
PREV_BLOCK_NUMBER=${LATEST_BLOCK_FILE%%.*}
PREV_BLOCK_NUMBER=$((${PREV_BLOCK_NUMBER#*_}-1))
PREV_BLOCK_FILE=block_${PREV_BLOCK_NUMBER}
PREV_BLOCK_HASH=$(md5sum $PREV_BLOCK_FILE | awk '{print $1}')

# loop through each block file
for FILE in $(find . -type f -iname "block_*" | sort -rn | cut -c 3- | head -n -1); do
	# generate a hash from the seed and previous block hash
	CHECK_HASH=$(printf '%s%s' "$(head -1 "${FILE}")" "${PREV_BLOCK_HASH}" | md5sum | awk '{print $1}')
	# check if hash starts with the correct number of zeros
	if [[ $CHECK_HASH == $(tail -1 "${FILE}" )* ]]; then
		echo "✅ $FILE $CHECK_HASH"
	else
		echo "❌ $FILE $CHECK_HASH"
	fi
	# prepare for checking previous block
	LATEST_BLOCK_FILE=${PREV_BLOCK_FILE}
	PREV_BLOCK_NUMBER=$((PREV_BLOCK_NUMBER-1))
	PREV_BLOCK_FILE=block_${PREV_BLOCK_NUMBER}
	# exit if block doesn't exist
	if [[ -f $PREV_BLOCK_FILE ]]; then
		PREV_BLOCK_HASH=$(md5sum $PREV_BLOCK_FILE | awk '{print $1}')
	else
		exit
	fi
done
