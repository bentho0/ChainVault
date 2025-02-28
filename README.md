# ChainVault

A decentralized document registry built on the Stacks blockchain.

## Overview

ChainVault provides an immutable, secure registry for document references on the blockchain. It allows users to register document references with validity periods, creating a tamper-proof record of document existence and ownership without storing the actual document content on-chain.

## Features

- **Secure Document Registration**: Register document references with blockchain-backed timestamps
- **Validity Timeframes**: Set custom validity periods for each document record
- **Reference Management**: Update document references while maintaining the audit trail
- **Creator Control**: Only document creators can modify or revoke their records
- **Tamper-proof**: All operations are secured by blockchain cryptography

## How It Works

ChainVault stores references to documents (such as hashes, URLs, or identifiers) rather than the documents themselves. This approach provides:

1. **Privacy**: Actual document contents remain off-chain
2. **Efficiency**: Minimal on-chain storage requirements
3. **Verifiability**: Timestamp proof of document existence
4. **Ownership**: Clear record of document creators

## Smart Contract Functions

### register-document

Register a new document reference with a specified validity period.

```clarity
(register-document "ipfs://QmWatXZZZ..." u720000)
```

### retrieve-document

Retrieve information about a registered document using its ID.

```clarity
(retrieve-document u1)
```

### modify-document

Update the reference or validity period of a document (creator only).

```clarity
(modify-document u1 "ipfs://QmNewHash..." u820000)
```

### revoke-document

Remove a document from the registry (creator only).

```clarity
(revoke-document u1)
```

## Use Cases

- **Legal Documents**: Prove existence of contracts at specific points in time
- **Intellectual Property**: Establish ownership claims for creative works
- **Academic Credentials**: Register educational certificates and achievements
- **Supply Chain**: Document product certifications and authenticity records
- **Healthcare**: Track medical record access references
- **Insurance**: Register policy documents and claim evidence

## Development

### Prerequisites

- Clarity language knowledge
- Stacks blockchain wallet
- Basic understanding of blockchain concepts

### Getting Started

1. Clone the repository
2. Install dependencies
3. Deploy to the Stacks blockchain using Clarinet or other deployment tools

## Security Considerations

- Document references are publicly visible
- Only reference data is stored, not actual document contents
- Validity periods automatically expire references
- Access controls ensure only creators can modify their documents
