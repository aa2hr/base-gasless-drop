# Base Mini App setup

This app now includes the files Base App looks for.

## Already in the repo

- `app/public/.well-known/farcaster.json` — Mini App manifest
- `app/index.html` — `fc:miniapp` embed metadata
- `app/src/miniapp.js` — calls `sdk.actions.ready()` inside Base App

## What you still do (needs your domain + wallet)

1. Deploy `app/` to HTTPS (Vercel is fine).
2. Replace every `REPLACE_WITH_YOUR_HTTPS_DOMAIN` in:
   - `app/public/.well-known/farcaster.json`
   - `app/index.html`
3. Confirm this URL works:
   `https://YOUR_DOMAIN/.well-known/farcaster.json`
4. Open [Base Build account association](https://docs.base.org/mini-apps/technical-guides/sign-manifest), paste the domain, sign with your Base/Farcaster wallet.
5. Paste `header`, `payload`, `signature` into `accountAssociation` and set `baseBuilder.ownerAddress`.
6. Redeploy.
7. In Base App, post the HTTPS URL once so it gets indexed.

Local `npm run dev` still works in the browser. Mini App discovery only happens after HTTPS + signed manifest.
