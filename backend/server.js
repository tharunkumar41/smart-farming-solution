const express = require('express');
const bodyParser = require("body-parser");
const { spawn } = require("child_process");
const axios = require('axios');
const cors = require('cors');
const mongoose = require('mongoose');
const path = require("path");
const app = express();
const PORT = 3000;
const FLASK_BACKEND_URL = 'http://127.0.0.1:5000';  // use 127.0.0.1 to avoid IPv6 issues

// --- Middleware ---
app.use(cors({
  origin: '*',
  methods: ['GET','POST','OPTIONS'],
  allowedHeaders: ['Content-Type','Authorization']
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// --- MongoDB Setup (single mongoose instance) ---
require('dotenv').config();
async function connectDB() {
  const mongoUri = process.env.MONGODB_URI;
  if (!mongoUri) {
    console.error('❌ MONGODB_URI environment variable not set');
    process.exit(1);
  }
  try {
    await mongoose.connect(mongoUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000
    });
    console.log('✅ Connected to MongoDB');
  } catch (err) {
    console.error('❌ MongoDB connection error:', err);
    // process.exit(1);
  }
}

// --- Load Inventory Routes & Models (from backend/routes and backend/models) ---
const inventoryAuth = require('./routes/auth');
const inventoryProducts = require('./routes/products');
const inventoryCategories = require('./routes/categories');
const inventoryCustomers = require('./routes/customers');
const inventorySales = require('./routes/sales');
const inventoryDashboard = require('./routes/dashboard');

// Mount inventory API
app.use('/api/inventory/auth', inventoryAuth);
app.use('/api/inventory/products', inventoryProducts);
app.use('/api/inventory/categories', inventoryCategories);
app.use('/api/inventory/customers', inventoryCustomers);
app.use('/api/inventory/sales', inventorySales);
app.use('/api/inventory/dashboard', inventoryDashboard);

// --- Serve Inventory Static Files under /inventory (corrected to backend/public/inventory) ---
// serve everything in backend/public/inventory at /inventory
app.use(
    '/inventory',
    express.static(path.resolve(__dirname, 'public', 'inventory'))
  );
  
// --- Serve login.html and dashboard.html pages for inventory ---  
app.get('/inventory/login', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'public', 'inventory', 'login.html'));
});

app.get('/inventory/dashboard', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'public', 'inventory', 'dashboard.html'));
});

// Optional: Serve inventory management page if exists
app.get('/inventory-management', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'public', 'inventory', 'inventory_management.html'));
});
  
// --- Serve Main App Static Files ---
const publicPath = path.join(__dirname, 'public');
const staticPath = path.join(__dirname, 'static');
app.use(express.static(publicPath));
app.use('/static', express.static(staticPath));

// --- Pages for Main App ---
app.get('/', (req, res) => res.sendFile(path.join(publicPath, 'index.html')));
app.get('/crop-recommendation', (req, res) => res.sendFile(path.join(publicPath, 'cr_module.html')));
app.get('/fertilizer-recommendation', (req, res) => res.sendFile(path.join(publicPath, 'fertilizer_module.html')));
app.get('/commodity', (req, res) => res.sendFile(path.join(publicPath, 'commodity.html')));

// Optional redirect from legacy link
app.get('/inventory-login', (req, res) => res.redirect('/inventory/login.html'));


// --- Flask Proxy Endpoints ---
[
  '/api/top5',
  '/api/bottom5',
  '/api/sixmonths',
  '/api/twelvemonths/:name',
  '/api/current/:name',
  '/api/commodity/:name'
].forEach(endpoint => {
  app.get(endpoint, async (req, res) => {
    try {
      const url = `${FLASK_BACKEND_URL}${req.path}`;
      const response = await axios.get(url);
      res.json(response.data);
    } catch (err) {
      console.error('Flask proxy error:', err);
      res.status(500).json({ error: 'Flask proxy failed', details: err.message });
    }
  });
});

// --- Python Model Routes ---
const PYTHON_BIN = path.resolve(__dirname, '..', 'venv', 'Scripts', 'python.exe'); 

app.post('/predict', (req, res) => {
  const { N, P, K, temperature, humidity, ph, rainfall } = req.body;
  const proc = spawn(PYTHON_BIN, [path.join(__dirname, 'ml_models', 'crop_predict.py'), N, P, K, temperature, humidity, ph, rainfall]);
  let out = '';
  proc.stdout.on('data', d => out += d.toString());
  proc.stderr.on('data', d => console.error('Python error:', d.toString()));
  proc.on('error', err => res.status(500).json({ error: 'Python spawn failed', details: err.message }));
  proc.on('close', code => code === 0 ? res.json({ crop: out.trim() }) : res.status(500).json({ error: 'Crop prediction failed' }));
});

app.post('/predict-fertilizer', (req, res) => {
  const { soilType, cropType, nitrogen, phosphorous, potassium } = req.body;
  const proc = spawn(PYTHON_BIN, [path.join(__dirname, 'ml_models', 'fertilizer_predict.py'), soilType, cropType, nitrogen, phosphorous, potassium]);
  let out = '';
  proc.stdout.on('data', d => out += d.toString());
  proc.stderr.on('data', d => console.error('Python error:', d.toString()));
  proc.on('error', err => res.status(500).json({ error: 'Python spawn failed', details: err.message }));
  proc.on('close', code => code === 0 ? res.json({ fertilizer: out.trim() }) : res.status(500).json({ error: 'Fertilizer prediction failed' }));
});

// --- Health Check ---
app.get('/health', (req, res) => res.json({ status: 'Unified Node server running' }));

// --- Boot the Server ---
(async () => {
  await connectDB();
  app.listen(PORT, () => console.log(`🚀 Server running at http://localhost:${PORT}`));
})();
