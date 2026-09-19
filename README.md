# base-gasless-drop

Gasless ERC-721 drop on **Base** (Coinbase L2). Mints are sponsored by a paymaster so the collector does not need ETH in their wallet.

Stack: Solidity + Foundry, Vite, viem, Coinbase Smart Wallet / paymaster hooks.

## Why Base

Base is cheap enough for consumer mints. Combined with [Coinbase Smart Wallet](https://docs.base.org/smart-wallet/quickstart) and a paymaster, a first-time user can mint from a passkey without holding gas.

## Layout

```
contracts/          Foundry ERC-721 drop
app/                Vite mint page
```

## Contracts

```bash
cd contracts
forge install
forge test
forge script script/Deploy.s.sol --rpc-url $BASE_SEPOLIA_RPC --broadcast --private-key $PRIVATE_KEY
```

Chain IDs: Base `8453`, Base Sepolia `84532`.

`Drop.sol` is an ERC-721 with:
- owner-controlled `mintPrice` (can be 0)
- `maxSupply`
- `mint(to)` callable by owner or by a trusted paymaster/bundler address
- URI prefix for metadata

## App

```bash
cd app
cp .env.example .env
npm install
npm run dev
```

Set:

- `VITE_DROP_ADDRESS` — deployed contract
- `VITE_PAYMASTER_URL` — Coinbase paymaster endpoint
- `VITE_CHAIN` — `base-sepolia` or `base`

Without live paymaster keys the UI still renders and falls back to a simulated sponsored mint so the repo stays demoable.

## Resume line

> Gasless ERC-721 drop on Base using Coinbase Smart Wallet and paymaster-sponsored transactions.

## License

MIT
