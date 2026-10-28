import json
import os
import socket
import uuid

from flask import Flask, jsonify, request, render_template_string

app = Flask(__name__)


@app.get("/whoami")
def whoami():
    return jsonify(instance=socket.gethostname())

PORT = int(os.environ.get("PORT", "8080"))

PRODUCTS = [
    {
        "id": "c1",
        "name": "Everyday Linen Shirt",
        "category": "clothing",
        "price": 1299,
        "emoji": "👕",
        "tag": "Bestseller",
    },
    {
        "id": "c2",
        "name": "Essential Sneakers",
        "category": "clothing",
        "price": 2499,
        "emoji": "👟",
        "tag": "New",
    },
    {
        "id": "c3",
        "name": "Classic Weekend Jacket",
        "category": "clothing",
        "price": 3299,
        "emoji": "🧥",
        "tag": "Popular",
    },
    {
        "id": "e1",
        "name": "Studio Wireless Headphones",
        "category": "electronics",
        "price": 4999,
        "emoji": "🎧",
        "tag": "Bestseller",
    },
    {
        "id": "e2",
        "name": "Smart Fitness Watch",
        "category": "electronics",
        "price": 3799,
        "emoji": "⌚",
        "tag": "New",
    },
    {
        "id": "e3",
        "name": "Portable Bluetooth Speaker",
        "category": "electronics",
        "price": 2199,
        "emoji": "🔊",
        "tag": "Popular",
    },
    {
        "id": "h1",
        "name": "Modular Storage Basket",
        "category": "home",
        "price": 799,
        "emoji": "🧺",
        "tag": "Bestseller",
    },
    {
        "id": "h2",
        "name": "Minimal Desk Organizer",
        "category": "home",
        "price": 1199,
        "emoji": "🪴",
        "tag": "New",
    },
    {
        "id": "h3",
        "name": "Space-Saving Shelf Set",
        "category": "home",
        "price": 1899,
        "emoji": "🗄️",
        "tag": "Popular",
    },
]

PAGE = r"""
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="theme-color" content="#101713">
<title>Forma — Thoughtfully Chosen Essentials</title>

<style>
:root {
  --ink: #17231d;
  --muted: #68756c;
  --paper: #f8f8f3;
  --green: #d6f36a;
  --line: #e5e8de;
  --white: #fff;
}

* { box-sizing: border-box; }

body {
  margin: 0;
  background: var(--paper);
  color: var(--ink);
  font: 16px/1.5 Inter, system-ui, -apple-system, sans-serif;
}

a { color: inherit; text-decoration: none; }
button, input { font: inherit; }
button { cursor: pointer; }

header {
  position: sticky;
  top: 0;
  z-index: 5;
  background: #f8f8f3ed;
  backdrop-filter: blur(14px);
  border-bottom: 1px solid var(--line);
}

.nav {
  max-width: 1180px;
  margin: auto;
  padding: 16px 22px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}

.logo {
  font-size: 24px;
  font-weight: 900;
  letter-spacing: -1.5px;
}

.logo span { color: #63801d; }

.links {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.links a {
  font-size: 14px;
  color: #48544b;
}

.cart-button, .dark-button {
  border: 0;
  border-radius: 99px;
  padding: 11px 17px;
  background: var(--ink);
  color: white;
  font-weight: 700;
}

main {
  max-width: 1180px;
  margin: auto;
  padding: 24px 22px 64px;
}

.hero {
  background: #17231d;
  color: white;
  border-radius: 26px;
  overflow: hidden;
  padding: clamp(28px, 6vw, 76px);
  position: relative;
  isolation: isolate;
}

.hero:after {
  content: "✳";
  position: absolute;
  right: 4%;
  top: 0;
  font-size: clamp(160px, 30vw, 360px);
  color: var(--green);
  opacity: .95;
  z-index: -1;
  transform: rotate(-12deg);
}

.eyebrow {
  text-transform: uppercase;
  letter-spacing: 2px;
  font-size: 11px;
  font-weight: 800;
  color: #b4d568;
}

h1 {
  font-size: clamp(40px, 7vw, 76px);
  letter-spacing: -4px;
  line-height: 1.02;
  max-width: 620px;
  margin: 18px 0;
}

.hero p {
  max-width: 440px;
  color: #d2dbd1;
}

.hero .dark-button {
  background: var(--green);
  color: var(--ink);
  margin-top: 12px;
}

.section-head {
  display: flex;
  justify-content: space-between;
  align-items: end;
  gap: 12px;
  margin: 44px 0 20px;
}

h2 {
  font-size: clamp(25px, 4vw, 36px);
  letter-spacing: -1.5px;
  margin: 0;
}

.section-head p {
  margin: 5px 0;
  color: var(--muted);
  font-size: 14px;
}

.search {
  width: min(270px, 45%);
  padding: 12px 15px;
  border-radius: 99px;
  border: 1px solid var(--line);
  background: white;
}

.categories {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin: 22px 0;
}

.chip {
  border: 1px solid #dce1d6;
  background: white;
  border-radius: 99px;
  padding: 10px 15px;
  font-size: 13px;
  font-weight: 700;
}

.chip.active {
  background: var(--green);
  border-color: var(--green);
}

.grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 20px;
}

.card {
  background: white;
  border: 1px solid var(--line);
  border-radius: 19px;
  padding: 12px;
  transition: transform .22s, box-shadow .22s;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 16px 40px #17231d12;
}

.art {
  height: 205px;
  border-radius: 13px;
  background: #edf0e6;
  display: grid;
  place-items: center;
  font-size: 84px;
  position: relative;
}

.tag {
  position: absolute;
  left: 12px;
  top: 12px;
  background: white;
  border-radius: 99px;
  padding: 5px 9px;
  font-size: 11px;
  font-weight: 800;
}

.card h3 {
  font-size: 16px;
  margin: 14px 0 4px;
}

.sub {
  color: var(--muted);
  font-size: 12px;
  text-transform: capitalize;
}

.buy {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
  margin-top: 15px;
}

.price { font-weight: 900; }

.add {
  background: var(--green);
  border: 0;
  border-radius: 99px;
  padding: 10px 13px;
  font-weight: 800;
}

.feature {
  margin-top: 42px;
  border: 1px solid var(--line);
  border-radius: 22px;
  padding: 24px;
  display: flex;
  justify-content: space-between;
  gap: 18px;
  align-items: center;
  background: #eff3e7;
}

footer {
  border-top: 1px solid var(--line);
  padding: 28px 22px;
  color: var(--muted);
  font-size: 13px;
  text-align: center;
}

.overlay {
  position: fixed;
  inset: 0;
  background: #10171366;
  z-index: 10;
  display: none;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.panel {
  background: white;
  border-radius: 22px;
  max-width: 500px;
  width: 100%;
  padding: 25px;
  max-height: 85vh;
  overflow: auto;
}

.cart-line {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  border-bottom: 1px solid var(--line);
  padding: 12px 0;
}

.qty {
  display: flex;
  gap: 9px;
  align-items: center;
  margin-top: 8px;
}

.qty button {
  border: 1px solid var(--line);
  background: white;
  border-radius: 7px;
  padding: 2px 8px;
}

.notice {
  color: #55731c;
  font-weight: 700;
  min-height: 24px;
}

@media(max-width:700px) {
  .links { gap: 10px; }
  .links a { font-size: 12px; }
  .grid { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px; }
  .art { height: 145px; font-size: 60px; }
  .nav { padding: 12px; }
  .logo { font-size: 20px; }
  .cart-button { padding: 9px 11px; }
  h1 { letter-spacing: -2px; }
  .feature { align-items: flex-start; flex-direction: column; }
}

@media(max-width:420px) {
  .links a:nth-child(3) { display: none; }
  .art { height: 120px; }
  .card { padding: 8px; }
  .buy { align-items: flex-start; flex-direction: column; }
}
</style>
</head>

<body>
<header>
<nav class="nav">
  <a class="logo" href="/">forma<span>.</span></a>
  <div class="links">
    <a href="/clothing">Clothing</a>
    <a href="/electronics">Electronics</a>
    <a href="/home">Home</a>
  </div>
  <button class="cart-button" onclick="openCart()">
    Bag <span id="count">0</span>
  </button>
</nav>
</header>

<main>
<section class="hero">
  <div class="eyebrow">Less clutter. More character.</div>
  <h1>Good things.<br>Chosen well.</h1>
  <p>Thoughtfully selected essentials for your wardrobe, your everyday tech, and the spaces you call home.</p>
  <button class="dark-button"
    onclick="document.getElementById('collection').scrollIntoView({behavior:'smooth'})">
    Explore the collection ↗
  </button>
</section>

<div class="section-head" id="collection">
  <div>
    <h2 id="heading">Considered essentials</h2>
    <p id="description">Everyday favorites, made to fit your life.</p>
  </div>
  <input class="search" id="search"
    placeholder="Search products…"
    oninput="render()"
    aria-label="Search products">
</div>

<div class="categories">
  <button class="chip" data-cat="all" onclick="setCategory('all')">All products</button>
  <button class="chip" data-cat="clothing" onclick="setCategory('clothing')">Clothing</button>
  <button class="chip" data-cat="electronics" onclick="setCategory('electronics')">Electronics</button>
  <button class="chip" data-cat="home" onclick="setCategory('home')">Home organization</button>
</div>

<div class="grid" id="products"></div>

<section class="feature">
  <div>
    <div class="eyebrow">A little more intentional</div>
    <h2>Make room for better.</h2>
    <p>Useful things, a little more beautiful.</p>
  </div>
  <button class="dark-button"
    onclick="window.scrollTo({top:0,behavior:'smooth'})">
    Back to top ↑
  </button>
</section>

<p class="notice" id="notice" aria-live="polite"></p>
</main>

<footer>
  FORMA © 2026 · Sample storefront · Checkout is simulated
</footer>

<div class="overlay" id="overlay"
  onclick="if(event.target===this)closeCart()">
  <div class="panel">
    <div style="display:flex;justify-content:space-between;align-items:center">
      <h2>Your bag</h2>
      <button class="chip" onclick="closeCart()">Close ✕</button>
    </div>

    <div id="cartlines"></div>
    <p id="total" style="font-size:20px;font-weight:900"></p>

    <button class="dark-button" style="width:100%" onclick="checkout()">
      Place test order
    </button>

    <p style="font-size:12px;color:#68756c">
      No payment is collected. This demo does not create a real order.
    </p>
    <div id="checkoutnotice" class="notice" aria-live="polite"></div>
  </div>
</div>

<script>
const products = __PRODUCTS__;

const path = location.pathname;
let active = path.startsWith('/clothing') ? 'clothing' :
  path.startsWith('/electronics') ? 'electronics' :
  path.startsWith('/home') ? 'home' : 'all';

let cart = {};

try {
  cart = JSON.parse(localStorage.getItem('forma-cart') || '{}');
  if (!cart || typeof cart !== 'object' || Array.isArray(cart)) cart = {};
} catch (_) {
  cart = {};
}

const money = n => '₹' + n.toLocaleString('en-IN');

function save() {
  const count = Object.values(cart).reduce((a, b) => a + b, 0);
  document.getElementById('count').textContent = count;

  try {
    localStorage.setItem('forma-cart', JSON.stringify(cart));
  } catch (_) {
    // The cart remains usable for the current page session.
  }
}

function setCategory(cat) {
  active = cat;

  const route = {
    all: '/',
    clothing: '/clothing',
    electronics: '/electronics',
    home: '/home'
  }[cat];

  history.pushState({}, '', route);
  render();
}

window.addEventListener('popstate', () => {
  const p = location.pathname;
  active = p.startsWith('/clothing') ? 'clothing' :
    p.startsWith('/electronics') ? 'electronics' :
    p.startsWith('/home') ? 'home' : 'all';

  render();
});

function render() {
  const q = document.getElementById('search').value.toLowerCase();

  const filtered = products.filter(p =>
    (active === 'all' || p.category === active) &&
    p.name.toLowerCase().includes(q)
  );

  document.getElementById('heading').textContent = ({
    all: 'Considered essentials',
    clothing: 'Wear it well',
    electronics: 'Everyday technology',
    home: 'A place for everything'
  })[active];

  document.getElementById('description').textContent = ({
    all: 'Everyday favorites, made to fit your life.',
    clothing: 'Easy pieces for your everyday rotation.',
    electronics: 'Useful technology, thoughtfully picked.',
    home: 'Small upgrades for calmer spaces.'
  })[active];

  document.querySelectorAll('.chip[data-cat]').forEach(button => {
    button.classList.toggle('active', button.dataset.cat === active);
  });

  document.getElementById('products').innerHTML =
    filtered.map(p => `
      <article class="card">
        <div class="art">
          <span class="tag">${p.tag}</span>
          ${p.emoji}
        </div>
        <div class="sub">${p.category}</div>
        <h3>${p.name}</h3>
        <div class="buy">
          <span class="price">${money(p.price)}</span>
          <button class="add" onclick="add('${p.id}')">Add +</button>
        </div>
      </article>
    `).join('') || '<p>No matching products found.</p>';

  save();
}

function add(id) {
  const product = products.find(p => p.id === id);
  if (!product) return;

  cart[id] = Math.min((cart[id] || 0) + 1, 20);
  save();
  renderCart();

  document.getElementById('notice').textContent =
    'Added to your bag ✓';
}

function openCart() {
  renderCart();
  document.getElementById('overlay').style.display = 'flex';
}

function closeCart() {
  document.getElementById('overlay').style.display = 'none';
}

function renderCart() {
  const lines = products.filter(p => cart[p.id]).map(p => `
    <div class="cart-line">
      <div>
        ${p.name}<br>
        <b>${money(p.price)}</b>
        <div class="qty">
          <button onclick="changeQty('${p.id}', -1)" aria-label="Decrease quantity">−</button>
          <span>${cart[p.id]}</span>
          <button onclick="changeQty('${p.id}', 1)" aria-label="Increase quantity">+</button>
        </div>
      </div>
      <b>${money(p.price * cart[p.id])}</b>
    </div>
  `).join('');

  document.getElementById('cartlines').innerHTML =
    lines || '<p>Your bag is empty.</p>';

  const total = products.reduce(
    (sum, p) => sum + p.price * (cart[p.id] || 0), 0
  );

  document.getElementById('total').textContent = 'Total: ' + money(total);
  save();
}

function changeQty(id, change) {
  const product = products.find(p => p.id === id);
  if (!product) return;

  cart[id] = (cart[id] || 0) + change;

  if (cart[id] <= 0) {
    delete cart[id];
  } else {
    cart[id] = Math.min(cart[id], 20);
  }

  save();
  renderCart();
}

async function checkout() {
  const notice = document.getElementById('checkoutnotice');
  const items = Object.keys(cart).map(id => ({
    id,
    quantity: cart[id]
  }));

  if (!items.length) {
    notice.textContent = 'Add a product first.';
    return;
  }

  notice.textContent = 'Processing demo order…';

  try {
    const response = await fetch('/api/checkout', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({items})
    });

    const data = await response.json();

    if (!response.ok) {
      notice.textContent = data.error || 'Checkout failed. Please retry.';
      return;
    }

    notice.textContent =
      'Demo order ' + data.order_id +
      ' confirmed · ' + money(data.total) +
      ' · no payment taken.';

    cart = {};
    save();
    renderCart();
  } catch (_) {
    notice.textContent = 'Unable to reach checkout. Please retry.';
  }
}

render();
</script>
</body>
</html>
"""


@app.get("/health")
def health():
    return jsonify(status="ok"), 200


@app.get("/api/products")
def api_products():
    return jsonify(PRODUCTS), 200


@app.post("/api/checkout")
def checkout():
    payload = request.get_json(silent=True)

    if not isinstance(payload, dict):
        return jsonify(error="A valid JSON request is required."), 400

    items = payload.get("items")

    if not isinstance(items, list) or not items or len(items) > len(PRODUCTS):
        return jsonify(error="Invalid cart."), 400

    catalog = {product["id"]: product for product in PRODUCTS}
    total = 0
    seen = set()

    for item in items:
        if not isinstance(item, dict):
            return jsonify(error="Invalid cart item."), 400

        product_id = item.get("id")
        quantity = item.get("quantity")

        if product_id in seen:
            return jsonify(error="Duplicate cart items are not allowed."), 400

        seen.add(product_id)
        product = catalog.get(product_id)

        if product is None:
            return jsonify(error="Unknown product."), 400

        if type(quantity) is not int or not 1 <= quantity <= 20:
            return jsonify(error="Quantity must be between 1 and 20."), 400

        total += product["price"] * quantity

    return jsonify(
        order_id="DEMO-" + uuid.uuid4().hex[:10].upper(),
        total=total,
        currency="INR",
        payment_status="simulated",
    ), 200


@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def storefront(path):
    page = PAGE.replace("__PRODUCTS__", json.dumps(PRODUCTS))
    return render_template_string(page), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
