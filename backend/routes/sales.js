const express = require('express');
const Sales = require('../models/Cart'); // Sales model is in Cart.js
const Product = require('../models/Product');

const router = express.Router();


  
// Get all sales
router.get('/', async (req, res) => {
  try {
    const sales = await Sales.find().populate('prdID').populate('customer');
    res.json(sales);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

  
// Get sales report by type: daily, weekly, monthly
router.get('/report/:type', async (req, res) => {
  const { type } = req.params;
  const now = new Date();
  let startDate;

  switch (type) {
    case 'daily':
      startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      break;
    case 'weekly':
      const day = now.getDay();
      startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() - day);
      break;
    case 'monthly':
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
      break;
    default:
      return res.status(400).json({ message: 'Invalid report type' });
  }

  try {
    const sales = await Sales.find({
      date: { $gte: startDate }
    }).populate('prdID').populate('customer');
    res.json(sales);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

  
// Add sale
router.post('/', async (req, res) => {
  const { prdID, quantity, customer, transcationID } = req.body;
  try {
    const product = await Product.findById(prdID);
    if (!product) return res.status(400).json({ message: 'Invalid product' });

    // Validate quantity
    if (quantity <= 0) {
      return res.status(400).json({ message: 'Quantity must be greater than zero' });
    }
    if (product.quantity < quantity) {
      return res.status(400).json({ message: 'Insufficient product quantity' });
    }

    const saleItem = new Sales({
      prdID,
      quantity,
      customer,
      transcationID,
      date: new Date()
    });
    await saleItem.save();

    // Update product quantity
    product.quantity -= quantity;
    await product.save();

    res.status(201).json(saleItem);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
