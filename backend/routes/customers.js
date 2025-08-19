const express = require('express');
const Customer = require('../models/Customer');

const router = express.Router();

// Get all customers
router.get('/', async (req, res) => {
  try {
    const customers = await Customer.find();
    res.json(customers);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Get customer by id
router.get('/:id', async (req, res) => {
  try {
    const customer = await Customer.findById(req.params.id);
    if (!customer) return res.status(404).json({ message: 'Customer not found' });
    res.json(customer);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Create new customer
router.post('/', async (req, res) => {
  const { fullName, phoneNo, email, address } = req.body;
  try {
    const existingCustomer = await Customer.findOne({ $or: [{ phoneNo }, { email }] });
    if (existingCustomer) return res.status(400).json({ message: 'Customer already exists' });

    const customer = new Customer({ fullName, phoneNo, email, address });
    await customer.save();
    res.status(201).json(customer);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Update customer
router.put('/:id', async (req, res) => {
  const { fullName, phoneNo, email, address } = req.body;
  try {
    const customer = await Customer.findById(req.params.id);
    if (!customer) return res.status(404).json({ message: 'Customer not found' });

    if (fullName) customer.fullName = fullName;
    if (phoneNo) customer.phoneNo = phoneNo;
    if (email) customer.email = email;
    if (address) customer.address = address;

    await customer.save();
    res.json(customer);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Delete customer
router.delete('/:id', async (req, res) => {
  try {
    const customer = await Customer.findByIdAndDelete(req.params.id);
    if (!customer) return res.status(404).json({ message: 'Customer not found' });
    res.json({ message: 'Customer deleted' });
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
