import './style.css';
import { base, baseSepolia } from 'viem/chains';

const chainName = import.meta.env.VITE_CHAIN || 'base-sepolia';
const chain = chainName === 'base' ? base : baseSepolia;
const drop = import.meta.env.VITE_DROP_ADDRESS || '0x0000000000000000000000000000000000000000';
const paymaster = import.meta.env.VITE_PAYMASTER_URL || '';

const app = document.querySelector('#app');
app.innerHTML = `
  <main>
    <p class="eyebrow">Base · chain ${chain.id}</p>
    <h1>Gasless Drop</h1>
    <p>Mint is sponsored by a paymaster. You do not need ETH in the wallet.</p>
    <p class="mono">contract ${drop}</p>
    <button id="mint">Mint (sponsored)</button>
    <pre id="log"></pre>
  </main>
`;

const log = document.querySelector('#log');
const btn = document.querySelector('#mint');

btn.addEventListener('click', async () => {
  log.textContent = 'Requesting sponsored mint…';
  try {
    if (!paymaster || drop.endsWith('0000')) {
      await new Promise((r) => setTimeout(r, 600));
      log.textContent = JSON.stringify({
        status: 'simulated',
        chain: chain.name,
        chainId: chain.id,
        to: drop,
        note: 'Set VITE_DROP_ADDRESS and VITE_PAYMASTER_URL for a live Coinbase paymaster mint.',
      }, null, 2);
      return;
    }
    const res = await fetch(paymaster, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ chainId: chain.id, to: drop, data: 'mint' }),
    });
    log.textContent = await res.text();
  } catch (err) {
    log.textContent = String(err);
  }
});
