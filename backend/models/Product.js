const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  productName: { type: String, required: true, unique: true, uppercase: true },
  productPrice: { type: Number, required: true },
  quantity: { type: Number, required: true },
  productCategory: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', required: true },
  date_create: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Product', productSchema);
