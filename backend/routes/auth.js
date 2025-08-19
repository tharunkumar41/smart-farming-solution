const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const router = express.Router();
const JWT_SECRET = 'your_jwt_secret_key'; // Change this to a secure key in production

// Register new user (optional, can be disabled if only admin user)
router.post('/register', async (req, res) => {
  const { username, password } = req.body;
  try {
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({ username, password: hashedPassword });
    await user.save();
    res.status(201).json({ message: 'User created' });
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});


// POST /api/inventory/auth/login (Make sure this matches your frontend request)
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }
    const token = jwt.sign({ username, role: 'user' }, JWT_SECRET, { expiresIn: '1d' });
    res.json({ token, username, role: 'user' });
  } catch (err) {
    console.error("Error during login:", err);
    res.status(500).json({ message: 'Server error' });
  }
});


// Login user
// router.post('/login', async (req, res) => {
//   const { username, password } = req.body;
//   try {
//     if(username === 'admin@admin.com' && password === 'pass3word') {
//       // Hardcoded admin user as in PHP project
//       const token = jwt.sign({ username, role: 'superAdmin' }, JWT_SECRET, { expiresIn: '1d' });
//       return res.json({ token, username, role: 'superAdmin' });
//     }
//     const user = await User.findOne({ username });
//     if (!user) {
//       return res.status(400).json({ message: 'Invalid credentials' });
//     }
//     const isMatch = await bcrypt.compare(password, user.password);
//     if (!isMatch) {
//       return res.status(400).json({ message: 'Invalid credentials' });
//     }
//     const token = jwt.sign({ username, role: 'user' }, JWT_SECRET, { expiresIn: '1d' });
//     res.json({ token, username, role: 'user' });
//   } catch (err) {
//     res.status(500).json({ message: 'Server error' });
//   }
// });

module.exports = router;
