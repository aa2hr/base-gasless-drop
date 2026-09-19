import './style.css';
import { base, baseSepolia } from 'viem/chains';

const chainName = import.meta.env.VITE_CHAIN || 'base-sepolia';
const chain = chainName === 'base' ? base : baseSepolia;
const configured = import.meta.env.VITE_DROP_ADDRESS || '';
const live = configured && !configured.endsWith('0000');
const drop = live ? configured : '0xDemoDrop0000000000000000000000000000Base';
const paymaster = import.meta.env.VITE_PAYMASTER_URL || '';

let nextId = Number(localStorage.getItem('bdrop-next') || '1');
const wallet = localStorage.getItem('bdrop-wallet') || randomAddr();
localStorage.setItem('bdrop-wallet', wallet);

const app = document.querySelector('#app');
app.innerHTML = `
  <main>
    <p class="eyebrow">Base · ${chain.name} · ${chain.id}</p>
    <h1>Gasless Drop</h1>
    <p>Paymaster pays the gas. Collector only signs the mint.</p>
    <div class="meta">
      <span class="pill">${live ? 'live contract' : 'demo mode'}</span>
      <span class="mono">${drop}</span>
    </div>
    <p class="mono">wallet ${wallet}</p>
    <button id="mint">Mint (sponsored)</button>
    <ul id="tokens"></ul>
    <pre id="log"></pre>
  </main>
`;

const log = document.querySelector('#log');
const tokens = document.querySelector('#tokens');
renderBag();

document.querySelector('#mint').addEventListener('click', mint);

async function mint() {
  log.textContent = 'Sponsoring user operation…';
  try {
    if (live && paymaster) {
      const res = await fetch(paymaster, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ chainId: chain.id, to: drop, from: wallet }),
      });
      log.textContent = await res.text();
      return;
    }
    await wait(700);
    const id = nextId++;
    localStorage.setItem('bdrop-next', String(nextId));
    const receipt = {
      status: 'sponsored',
      mode: 'demo',
      chain: chain.name,
      chainId: chain.id,
      contract: drop,
      to: wallet,
      tokenId: id,
      txHash: fakeTx(),
      gasPaidBy: 'paymaster',
      userPaidEth: '0',
    };
    const bag = readBag();
    bag.unshift(receipt);
    localStorage.setItem('bdrop-bag', JSON.stringify(bag.slice(0, 8)));
    renderBag();
    log.textContent = JSON.stringify(receipt, null, 2);
  } catch (err) {
    log.textContent = String(err);
  }
}

function readBag() {
  try { return JSON.parse(localStorage.getItem('bdrop-bag') || '[]'); }
  catch { return []; }
}

function renderBag() {
  const bag = readBag();
  tokens.innerHTML = bag.map((t) => `<li>#${t.tokenId} → ${t.to.slice(0, 6)}…${t.to.slice(-4)}</li>`).join('')
    || '<li class="empty">No mints yet</li>';
}

function randomAddr() {
  const bytes = crypto.getRandomValues(new Uint8Array(20));
  return '0x' + [...bytes].map((b) => b.toString(16).padStart(2, '0')).join('');
}

function fakeTx() {
  const bytes = crypto.getRandomValues(new Uint8Array(32));
  return '0x' + [...bytes].map((b) => b.toString(16).padStart(2, '0')).join('');
}

function wait(ms) {
  return new Promise((r) => setTimeout(r, ms));
}
