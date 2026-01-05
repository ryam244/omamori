/**
 * Order Processing System - REFACTORED VERSION
 * Improved version with separated concerns and better maintainability
 */

// ========== Configuration ==========
const PRODUCT_PRICES = {
  'PROD-A': 29.99,
  'PROD-B': 49.99,
  'PROD-C': 19.99,
  'DEFAULT': 39.99
};

const PRODUCT_INVENTORY = {
  'PROD-A': 100,
  'PROD-B': 50,
  'PROD-C': 200,
  'DEFAULT': 75
};

const QUANTITY_DISCOUNTS = [
  { minQuantity: 10, discountRate: 0.20 },
  { minQuantity: 5, discountRate: 0.10 }
];

const CUSTOMER_DISCOUNTS = {
  'PREMIUM': { minAmount: 100, discountRate: 0.05 },
  'VIP': { minAmount: 100, discountRate: 0.10 }
};

const HIGH_VALUE_ORDER_THRESHOLD = 500;

// ========== Validation Functions ==========
function validateOrder(order) {
  if (!order) {
    return { isValid: false, error: "Order is required" };
  }

  const customerValidation = validateCustomer(order.customerId);
  if (!customerValidation.isValid) {
    return customerValidation;
  }

  const itemsValidation = validateItems(order.items);
  if (!itemsValidation.isValid) {
    return itemsValidation;
  }

  return { isValid: true };
}

function validateCustomer(customerId) {
  if (!customerId || typeof customerId !== 'string') {
    return { isValid: false, error: "Invalid customer ID" };
  }
  return { isValid: true };
}

function validateItems(items) {
  if (!items || !Array.isArray(items) || items.length === 0) {
    return { isValid: false, error: "Order must contain at least one item" };
  }

  for (let i = 0; i < items.length; i++) {
    const itemValidation = validateItem(items[i], i);
    if (!itemValidation.isValid) {
      return itemValidation;
    }
  }

  return { isValid: true };
}

function validateItem(item, index) {
  if (!item.productId || typeof item.productId !== 'string') {
    return { isValid: false, error: `Invalid product ID for item ${index}` };
  }

  if (!item.quantity || typeof item.quantity !== 'number' || item.quantity <= 0) {
    return { isValid: false, error: `Invalid quantity for item ${index}` };
  }

  return { isValid: true };
}

// ========== Pricing Functions ==========
function getProductPrice(productId) {
  for (const prefix in PRODUCT_PRICES) {
    if (productId.startsWith(prefix)) {
      return PRODUCT_PRICES[prefix];
    }
  }
  return PRODUCT_PRICES.DEFAULT;
}

function calculateItemTotal(item) {
  const unitPrice = getProductPrice(item.productId);
  return unitPrice * item.quantity;
}

function applyQuantityDiscount(itemTotal, quantity) {
  for (const discount of QUANTITY_DISCOUNTS) {
    if (quantity >= discount.minQuantity) {
      return itemTotal * (1 - discount.discountRate);
    }
  }
  return itemTotal;
}

function calculateItemsTotal(items) {
  return items.reduce((total, item) => total + calculateItemTotal(item), 0);
}

function calculateDiscountedTotal(items) {
  return items.reduce((total, item) => {
    const itemTotal = calculateItemTotal(item);
    const discountedItemTotal = applyQuantityDiscount(itemTotal, item.quantity);
    return total + discountedItemTotal;
  }, 0);
}

function applyCustomerDiscount(amount, customerType) {
  const discount = CUSTOMER_DISCOUNTS[customerType];

  if (discount && amount >= discount.minAmount) {
    return amount * (1 - discount.discountRate);
  }

  return amount;
}

function calculatePricing(items, customerType) {
  const totalPrice = calculateItemsTotal(items);
  const discountedPrice = calculateDiscountedTotal(items);
  const finalPrice = applyCustomerDiscount(discountedPrice, customerType);

  return {
    totalPrice,
    discountedPrice,
    finalPrice,
    savings: totalPrice - finalPrice
  };
}

// ========== Inventory Functions ==========
function getAvailableStock(productId) {
  for (const prefix in PRODUCT_INVENTORY) {
    if (productId.startsWith(prefix)) {
      return PRODUCT_INVENTORY[prefix];
    }
  }
  return PRODUCT_INVENTORY.DEFAULT;
}

function checkItemInventory(item) {
  const availableStock = getAvailableStock(item.productId);

  if (item.quantity > availableStock) {
    return {
      hasIssue: true,
      productId: item.productId,
      requested: item.quantity,
      available: availableStock
    };
  }

  return { hasIssue: false };
}

function checkInventory(items) {
  const inventoryIssues = items
    .map(checkItemInventory)
    .filter(result => result.hasIssue);

  return {
    hasIssues: inventoryIssues.length > 0,
    issues: inventoryIssues
  };
}

// ========== Notification Functions ==========
function sendHighValueOrderNotification(customerId, finalPrice) {
  console.log(`High-value order alert for customer ${customerId}: $${finalPrice.toFixed(2)}`);
  return 'high-value-alert';
}

function sendVipNotification(customerId) {
  console.log(`VIP order received for customer ${customerId}`);
  return 'vip-notification';
}

function sendOrderConfirmation(customerId) {
  console.log(`Order confirmation sent to customer ${customerId}`);
  return 'order-confirmation';
}

function sendNotifications(customerId, customerType, finalPrice) {
  const notificationsSent = [];

  if (finalPrice >= HIGH_VALUE_ORDER_THRESHOLD) {
    notificationsSent.push(sendHighValueOrderNotification(customerId, finalPrice));
  }

  if (customerType === 'VIP') {
    notificationsSent.push(sendVipNotification(customerId));
  }

  notificationsSent.push(sendOrderConfirmation(customerId));

  return notificationsSent;
}

// ========== Main Order Processing Function ==========
function processOrder(order) {
  // Step 1: Validate order
  const validation = validateOrder(order);
  if (!validation.isValid) {
    return { success: false, error: validation.error };
  }

  // Step 2: Check inventory
  const inventoryCheck = checkInventory(order.items);
  if (inventoryCheck.hasIssues) {
    return {
      success: false,
      error: "Insufficient inventory",
      inventoryIssues: inventoryCheck.issues
    };
  }

  // Step 3: Calculate pricing
  const pricing = calculatePricing(order.items, order.customerType);

  // Step 4: Send notifications
  const notificationsSent = sendNotifications(
    order.customerId,
    order.customerType,
    pricing.finalPrice
  );

  // Step 5: Return success response
  return {
    success: true,
    orderId: `ORD-${Date.now()}`,
    customerId: order.customerId,
    ...pricing,
    notificationsSent
  };
}

// ========== Example Usage ==========
const sampleOrder = {
  customerId: 'CUST-123',
  customerType: 'PREMIUM',
  items: [
    { productId: 'PROD-A-001', quantity: 5 },
    { productId: 'PROD-B-002', quantity: 3 }
  ]
};

console.log(processOrder(sampleOrder));

module.exports = {
  processOrder,
  // Exporting individual functions for testing
  validateOrder,
  calculatePricing,
  checkInventory,
  sendNotifications
};
