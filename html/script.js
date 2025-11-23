const appRoot = document.getElementById('app-root');
const gridEl = document.getElementById('vehicleGrid');
const dealerNameEl = document.getElementById('dealerName');
const sortPriceBtn = document.getElementById('sortPrice');

const detailPanel = document.getElementById('detailPanel');
const detailBack = document.getElementById('detailBack');
const detailClose = document.getElementById('detailClose');
const detailName = document.getElementById('detailName');
const detailPrice = document.getElementById('detailPrice');
const detailInitials = document.getElementById('detailInitials');
const detailImage = document.getElementById('detailImage');
const detailCopy = document.getElementById('detailCopy');
const colorRow = document.getElementById('colorRow');
const statSpeed = document.getElementById('statSpeed');
const statAccel = document.getElementById('statAccel');
const statBraking = document.getElementById('statBraking');
const statTraction = document.getElementById('statTraction');
const buyButton = document.getElementById('buyButton');

let currentDealer = null;
let allVehicles = [];
let filteredVehicles = [];
let selectedCategory = 'featured';
let sortAscending = true;
let selectedVehicle = null;
let selectedColor = null;

const colorSwatches = {
  red: '#d0202a',
  blue: '#3471d4',
  green: '#3fa772',
  yellow: '#f4c842',
  black: '#111111',
  white: '#f3f3f3'
};

// Default fallback image
const DEFAULT_IMGIMP = 'https://imgimp.xyz/images/Stoic-2025-11-22_23-41-40-69224a34db3a9.png';

// Optional hard overrides if you ever want them.
// Now only used as *fallback* if config.imageUrl is empty.
const imageOverrides = {
  blista: DEFAULT_IMGIMP,
  issi2:  DEFAULT_IMGIMP,
  futo:   DEFAULT_IMGIMP,
  italirsx: DEFAULT_IMGIMP,
  pariah: DEFAULT_IMGIMP,
};

function getResourceName() {
  return (window.GetParentResourceName && GetParentResourceName()) || 'apx-legendary-shop';
}

function showApp() {
  appRoot.classList.remove('hidden');
}

function hideApp() {
  appRoot.classList.add('hidden');
}

function openDetail() {
  detailPanel.classList.remove('hidden');
}

function closeDetail() {
  detailPanel.classList.add('hidden');
  selectedVehicle = null;
}

function formatPrice(value) {
  if (typeof value !== 'number') value = Number(value) || 0;
  return '$' + value.toLocaleString();
}

function applyCategoryFilter() {
  if (!allVehicles.length) {
    filteredVehicles = [];
    return;
  }

  if (selectedCategory === 'featured') {
    filteredVehicles = [...allVehicles];
  } else {
    filteredVehicles = allVehicles.filter(v => (v.category || '').toLowerCase() === selectedCategory);
  }
}

function applySort() {
  filteredVehicles.sort((a, b) => {
    const av = Number(a.price) || 0;
    const bv = Number(b.price) || 0;
    return sortAscending ? av - bv : bv - av;
  });
}

function renderTabs() {
  document.querySelectorAll('.tab').forEach(tab => {
    const cat = tab.dataset.cat;
    tab.classList.toggle('active', cat === selectedCategory);
  });
}

function renderGrid() {
  gridEl.innerHTML = '';

  if (!filteredVehicles.length) {
    const empty = document.createElement('div');
    empty.style.gridColumn = '1 / -1';
    empty.style.textAlign = 'center';
    empty.style.padding = '30px 0';
    empty.textContent = 'No vehicles configured for this category.';
    gridEl.appendChild(empty);
    return;
  }

  filteredVehicles.forEach(v => {
    // Use config URL first, then override, then default
    const configUrl   = (v.imageUrl || '').trim();
    const overrideUrl = imageOverrides[v.id];
    const effectiveUrl = configUrl || overrideUrl || DEFAULT_IMGIMP;

    console.log('[Legendary] grid vehicle:', v.id, 'configUrl:', v.imageUrl, 'effectiveUrl:', effectiveUrl);

    const card = document.createElement('div');
    card.className = 'vehicle-card';
    card.dataset.id = v.id;

    const thumb = document.createElement('div');
    thumb.className = 'vehicle-thumb';

    const img = document.createElement('img');
    img.src = effectiveUrl;
    img.alt = v.name || v.model || 'Vehicle image';
    thumb.appendChild(img);

    const info = document.createElement('div');
    info.className = 'vehicle-info';

    const nameEl = document.createElement('div');
    nameEl.className = 'vehicle-name';
    nameEl.textContent = v.name || v.model || 'Vehicle';

    const priceEl = document.createElement('div');
    priceEl.className = 'vehicle-price';
    priceEl.textContent = formatPrice(v.price);

    const tagEl = document.createElement('div');
    tagEl.className = 'vehicle-tagline';
    tagEl.textContent = (v.category || '').toUpperCase() || 'VEHICLE';

    info.appendChild(nameEl);
    info.appendChild(priceEl);
    info.appendChild(tagEl);

    card.appendChild(thumb);
    card.appendChild(info);

    card.addEventListener('click', () => {
      openDetailForVehicle(v);
    });

    gridEl.appendChild(card);
  });
}

function setStatBar(el, value) {
  const clamped = Math.max(0, Math.min(4, Number(value) || 0));
  const pct = (clamped / 4) * 100;
  el.style.width = pct + '%';
}

function renderColors(vehicle) {
  colorRow.innerHTML = '';
  const colors = vehicle.colors && vehicle.colors.length ? vehicle.colors : Object.keys(colorSwatches);

  colors.forEach(colorName => {
    const dot = document.createElement('div');
    dot.className = 'color-dot';
    dot.dataset.color = colorName;
    dot.style.backgroundColor = colorSwatches[colorName] || '#ffffff';

    if (!selectedColor) selectedColor = colorName;
    if (selectedColor === colorName) {
      dot.classList.add('selected');
    }

    dot.addEventListener('click', () => {
      selectedColor = colorName;
      document.querySelectorAll('.color-dot').forEach(d => d.classList.remove('selected'));
      dot.classList.add('selected');
    });

    colorRow.appendChild(dot);
  });
}

function openDetailForVehicle(vehicle) {
  selectedVehicle = vehicle;
  selectedColor = null;

  const configUrl   = (vehicle.imageUrl || '').trim();
  const overrideUrl = imageOverrides[vehicle.id];
  const effectiveUrl = configUrl || overrideUrl || DEFAULT_IMGIMP;

  console.log('[Legendary] open detail for:', vehicle.id, 'configUrl:', vehicle.imageUrl, 'effectiveUrl:', effectiveUrl);

  detailName.textContent = vehicle.name || vehicle.model || 'Vehicle';
  detailPrice.textContent = formatPrice(vehicle.price);
  detailCopy.textContent = vehicle.blurb || "Fresh from Larry's RV front lot, ready to ruin your savings account.";

  const initials = (vehicle.name || vehicle.model || 'APX')
    .split(' ')
    .map(p => p[0])
    .join('')
    .slice(0, 3)
    .toUpperCase();

  detailInitials.textContent = initials;

  detailImage.style.display = 'block';
  detailInitials.style.display = 'none';
  detailImage.src = effectiveUrl;

  const stats = vehicle.stats || {};
  setStatBar(statSpeed, stats.speed);
  setStatBar(statAccel, stats.accel);
  setStatBar(statBraking, stats.braking);
  setStatBar(statTraction, stats.traction);

  renderColors(vehicle);
  openDetail();
}

function handleBuy() {
  if (!currentDealer || !selectedVehicle) return;

  const payload = {
    dealershipId: currentDealer.id,
    vehicleId: selectedVehicle.id,
    colorName: selectedColor
  };

  console.log('[Legendary] sending buyVehicle payload:', payload);

  fetch(`https://${getResourceName()}/buyVehicle`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(payload)
  }).catch(() => {});
}

function requestClose() {
  handleCloseShop();

  fetch(`https://${getResourceName()}/close`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify({})
  }).catch(() => {});
}

function handleOpenShop(data) {
  console.log('[Legendary] handleOpenShop data:', data);

  currentDealer = data || {};
  dealerNameEl.textContent = currentDealer.label || "Larry's RV & Performance";

  allVehicles = Array.isArray(currentDealer.stock) ? currentDealer.stock.slice() : [];
  selectedCategory = 'featured';
  sortAscending = true;
  renderTabs();
  applyCategoryFilter();
  applySort();
  renderGrid();
  showApp();
  closeDetail();
}

function handleCloseShop() {
  currentDealer = null;
  allVehicles = [];
  filteredVehicles = [];
  closeDetail();
  hideApp();
}

window.addEventListener('message', (event) => {
  const data = event.data || {};
  if (!data.action) return;

  if (data.action === 'openShop') {
    handleOpenShop(data.dealership);
  } else if (data.action === 'closeShop') {
    handleCloseShop();
  }
});

// Tabs
document.querySelectorAll('.tab').forEach(tab => {
  tab.addEventListener('click', () => {
    const cat = tab.dataset.cat;
    selectedCategory = cat;
    renderTabs();
    applyCategoryFilter();
    applySort();
    renderGrid();
  });
});

// Sort
sortPriceBtn.addEventListener('click', () => {
  sortAscending = !sortAscending;
  applySort();
  renderGrid();
});

// Back button
detailBack.addEventListener('click', (e) => {
  e.preventDefault();
  closeDetail();
});

// Close button
detailClose.addEventListener('click', (e) => {
  e.preventDefault();
  closeDetail();
});

// Buy
buyButton.addEventListener('click', () => {
  handleBuy();
});

// ESC: close shop entirely
document.addEventListener('keyup', (ev) => {
  if (ev.key === 'Escape' || ev.key === 'Esc' || ev.keyCode === 27) {
    requestClose();
  }
});
