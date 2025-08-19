const express = require('express');
const Product = require('../models/Product');
const Category = require('../models/Category');
const Customer = require('../models/Customer');
const Sales = require('../models/Cart'); // Sales model is in Cart.js

const router = express.Router();

router.get('/overview', async (req, res) => {
  try {
    const totalProducts = await Product.countDocuments();
    const totalCategories = await Category.countDocuments();
    const totalCustomers = await Customer.countDocuments();
    const totalSales = await Sales.countDocuments();

    res.json({
      totalProducts,
      totalCategories,
      totalCustomers,
      totalSales
    });
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// New endpoint: sales data aggregated by date for last 30 days
router.get('/sales-trends', async (req, res) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 29); // last 30 days including today

    const salesData = await Sales.aggregate([
      {
        $match: {
          date: { $gte: thirtyDaysAgo }
        }
      },
      {
        $group: {
          _id: {
            year: { $year: "$date" },
            month: { $month: "$date" },
            day: { $dayOfMonth: "$date" }
          },
          totalQuantity: { $sum: "$quantity" }
        }
      },
      {
        $sort: { "_id.year": 1, "_id.month": 1, "_id.day": 1 }
      }
    ]);

    // Format data for frontend
    const formattedData = salesData.map(item => {
      const { year, month, day } = item._id;
      const dateStr = new Date(year, month - 1, day).toISOString().split('T')[0];
      return { date: dateStr, totalQuantity: item.totalQuantity };
    });

    res.json(formattedData);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});

// New endpoint: detailed sales data for visualizations
router.get('/sales-data', async (req, res) => {
  try {
    const sales = await Sales.find().populate('prdID').populate('customer');
const formattedSales = sales.map(sale => ({
  Product: sale.prdID ? sale.prdID.productName : 'Unknown',
  Customer: sale.customer ? sale.customer.fullName : 'Unknown',
  Quantity: sale.quantity,
  Date: sale.date ? sale.date.toISOString().split('T')[0] : ''
}));
    res.json(formattedSales);
  } catch (err) {
    res.status(500).json({ message: 'Server error' });
  }
});


module.exports = router;
