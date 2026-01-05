/**
 * Order Processing System
 * This file contains a complex order processing function that needs refactoring
 */

/**
 * Process an order with validation, pricing, inventory check, and notifications
 * BEFORE REFACTORING - This function is overly complex with multiple responsibilities
 */
function processOrder(order) {
  // Validate order
  if (!order) {
    return { success: false, error: "Order is required" };
  }

  if (!order.customerId || typeof order.customerId !== 'string') {
    return { success: false, error: "Invalid customer ID" };
  }

  if (!order.items || !Array.isArray(order.items) || order.items.length === 0) {
    return { success: false, error: "Order must contain at least one item" };
  }

  // Check each item
  for (let i = 0; i < order.items.length; i++) {
    if (!order.items[i].productId || typeof order.items[i].productId !== 'string') {
      return { success: false, error: `Invalid product ID for item ${i}` };
    }
    if (!order.items[i].quantity || typeof order.items[i].quantity !== 'number' || order.items[i].quantity <= 0) {
      return { success: false, error: `Invalid quantity for item ${i}` };
    }
  }

  // Calculate total price
  let totalPrice = 0;
  let discountedPrice = 0;

  for (let i = 0; i < order.items.length; i++) {
    // Simulate price lookup
    let itemPrice = 0;
    if (order.items[i].productId.startsWith('PROD-A')) {
      itemPrice = 29.99;
    } else if (order.items[i].productId.startsWith('PROD-B')) {
      itemPrice = 49.99;
    } else if (order.items[i].productId.startsWith('PROD-C')) {
      itemPrice = 19.99;
    } else {
      itemPrice = 39.99;
    }

    let itemTotal = itemPrice * order.items[i].quantity;
    totalPrice += itemTotal;

    // Apply discounts based on quantity
    if (order.items[i].quantity >= 10) {
      discountedPrice += itemTotal * 0.8; // 20% off
    } else if (order.items[i].quantity >= 5) {
      discountedPrice += itemTotal * 0.9; // 10% off
    } else {
      discountedPrice += itemTotal;
    }
  }

  // Apply customer-level discounts
  let finalPrice = discountedPrice;
  if (order.customerType === 'PREMIUM' && discountedPrice >= 100) {
    finalPrice = discountedPrice * 0.95; // Additional 5% off for premium customers
  } else if (order.customerType === 'VIP' && discountedPrice >= 100) {
    finalPrice = discountedPrice * 0.9; // Additional 10% off for VIP customers
  }

  // Check inventory
  let inventoryIssues = [];
  for (let i = 0; i < order.items.length; i++) {
    // Simulate inventory check
    let availableStock = 0;
    if (order.items[i].productId.startsWith('PROD-A')) {
      availableStock = 100;
    } else if (order.items[i].productId.startsWith('PROD-B')) {
      availableStock = 50;
    } else if (order.items[i].productId.startsWith('PROD-C')) {
      availableStock = 200;
    } else {
      availableStock = 75;
    }

    if (order.items[i].quantity > availableStock) {
      inventoryIssues.push({
        productId: order.items[i].productId,
        requested: order.items[i].quantity,
        available: availableStock
      });
    }
  }

  if (inventoryIssues.length > 0) {
    return {
      success: false,
      error: "Insufficient inventory",
      inventoryIssues: inventoryIssues
    };
  }

  // Send notifications
  let notificationsSent = [];
  if (finalPrice >= 500) {
    // Send high-value order notification
    console.log(`High-value order alert for customer ${order.customerId}: $${finalPrice.toFixed(2)}`);
    notificationsSent.push('high-value-alert');
  }

  if (order.customerType === 'VIP') {
    // Send VIP notification
    console.log(`VIP order received for customer ${order.customerId}`);
    notificationsSent.push('vip-notification');
  }

  // Send order confirmation
  console.log(`Order confirmation sent to customer ${order.customerId}`);
  notificationsSent.push('order-confirmation');

  // Return success
  return {
    success: true,
    orderId: `ORD-${Date.now()}`,
    customerId: order.customerId,
    totalPrice: totalPrice,
    discountedPrice: discountedPrice,
    finalPrice: finalPrice,
    savings: totalPrice - finalPrice,
    notificationsSent: notificationsSent
  };
}

// Example usage
const sampleOrder = {
  customerId: 'CUST-123',
  customerType: 'PREMIUM',
  items: [
    { productId: 'PROD-A-001', quantity: 5 },
    { productId: 'PROD-B-002', quantity: 3 }
  ]
};

console.log(processOrder(sampleOrder));

module.exports = { processOrder };
