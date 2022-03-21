# Bashchain

A simple chain of block files which generate hashes with leading zeros.

This is a simple implementation to demonstrate how the Bitcoin blockchain works.
The bitcoin blockchain validates data based on the previous block with leading zeros.

## Run bashchain

Generate an initial block
```
printf "$(uuidgen)\n000" > block_0
```

Run bashchain until it finds the correct hash
```
./bashchain

block_1 written
from seed 272855f0-4a9f-4932-a807-17dcacd0b118
with hash 00d033b7141b2ae7631c940928e3f0ee
in 247 iterations
```

Run it with more leading zeros
```
./bashchain 4

block_2 written
from seed 5b31e9f1-2117-4985-98a4-21c3b663edce
with hash 000033e07193806c4f7f41b4b9f3ef39
in 82982 iterations 
```

## Validate chain

You can validate the chain to make sure each seed and hash are correct.

```
./validate

✅ block_6 00005f519870a05f50ced2079e1ae5da
✅ block_5 0bfdf668c880a4965d550852514147ca
✅ block_4 00047a3a96966de6d1f6b8a535e31f2d
✅ block_3 00098b505ad8d9ade8d0e1a648accb6f
✅ block_2 0000eeaad0b83cf87d1181a538b26d81
✅ block_1 004ed0b92717cabf541c47a12cac1e9c
```
