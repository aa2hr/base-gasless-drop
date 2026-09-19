export async function notifyReady() {
  try {
    const mod = await import("@farcaster/miniapp-sdk");
    const sdk = mod.sdk ?? mod.default;
    if (sdk?.actions?.ready) await sdk.actions.ready();
  } catch {
    // Running in a normal browser, not Base App.
  }
}
