const express = require('express');
const Product = require('../models/Product');
const Category = require('../models/Category');

const router = express.Router();

// Get all products
router.get('/', async (req, res) => {
  try {
    const products = await Product.find().populate('productCategory');
    res.json(products);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Get product by id
router.get('/:id', async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate('productCategory');
    if (!product) return res.status(404).json({ message: 'Product not found' });
    res.json(product);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Create new product
router.post('/', async (req, res) => {
  const { productName, productPrice, quantity, productCategory } = req.body;
  try {
    const category = await Category.findById(productCategory);
    if (!category) return res.status(400).json({ message: 'Invalid category' });

    const existingProduct = await Product.findOne({ productName: productName.toUpperCase() });
    if (existingProduct) return res.status(400).json({ message: 'Product already exists' });

    const product = new Product({
      productName: productName.toUpperCase(),
      productPrice,
      quantity,
      productCategory
    });
    await product.save();
    res.status(201).json(product);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Update product
router.put('/:id', async (req, res) => {
  const { productName, productPrice, quantity, productCategory } = req.body;
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product not found' });

    if (productName) product.productName = productName.toUpperCase();
    if (productPrice !== undefined) product.productPrice = productPrice;
    if (quantity !== undefined) product.quantity = quantity;
    if (productCategory) {
      const category = await Category.findById(productCategory);
      if (!category) return res.status(400).json({ message: 'Invalid category' });
      product.productCategory = productCategory;
    }

    await product.save();
    res.json(product);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Delete product
router.delete('/:id', async (req, res) => {
  try {
    const product = await Product.findByIdAndDelete(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product not found' });
    res.json({ message: 'Product deleted' });
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
