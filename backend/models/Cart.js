const mongoose = require('mongoose');

const salesSchema = new mongoose.Schema({
  prdID: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true },
  quantity: { type: Number, required: true },
  date: { type: Date, default: Date.now },
  customer: { type: mongoose.Schema.Types.ObjectId, ref: 'Customer', required: true },
  transcationID: { type: String }
});

module.exports = mongoose.model('Sales', salesSchema);
