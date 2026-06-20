export const generateSKU = (categoryName, productName, index) => {
  const cat = categoryName.substring(0, 3).toUpperCase();
  const prod = productName.substring(0, 3).toUpperCase();
  const num = String(index).padStart(4, "0");
  return `${cat}-${prod}-${num}`;
};

export const generateOrderNumber = () => {
  const timestamp = Date.now().toString(36).toUpperCase();
  const random = Math.random().toString(36).substring(2, 6).toUpperCase();
  return `LM-${timestamp}-${random}`;
};

export const generateInvoiceNumber = (orderId) => {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  return `INV-${year}${month}-${String(orderId).padStart(6, "0")}`;
};

export const calculateDiscount = (price, offerPrice) => {
  if (!price || !offerPrice || price <= 0) return 0;
  return Math.round(((price - offerPrice) / price) * 100);
};