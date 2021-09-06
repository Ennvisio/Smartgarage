export const state = () => ({
  purchaseItems: [],
  sellItems: [],
  invoiceItems: [],
  transferItems: [],
  purchase_discount: 0,
  sell_discount: 0,
  invoice_discount: 0,
  purchase_tax: 0,
  sell_tax: 0,
  invoice_tax: 0,
  shipping_cost: 0,
  sell_shipping_cost: 0,
  transfer_shipping_cost:0
});
export const getters = {
  getPurchaseItems(state) {
    return state.purchaseItems;
  },

  getInvoiceItems(state) {
    return state.invoiceItems;
  },

  transferTotalPrice(state,getters){
    let price = getters.transferSubTotalPrice;
    let shipping_cost = state.transfer_shipping_cost;
    let totalamount = parseInt(price) + parseInt(shipping_cost);
    return totalamount;
  },
  transferSubTotalPrice(state, getters) {
    let items = getters.getTransferItems;
    let price = 0;
    if (items && items.length) {
      items.forEach(item => {
        price += Number(item.subtotal);
      });
    }
    return price;
  },
  totalPrice(state, getters) {
    let price = getters.subTotalPrice;
    let purchase_discount = state.purchase_discount;
    let purchase_tax = state.purchase_tax;
    // let shipping_cost = state.shipping_cost;
    let discount_percentage = (price * purchase_tax) / 100;
    let after_tax = price + discount_percentage;
    let after_discount = after_tax - purchase_discount;
    let totalamount = parseInt(after_discount);
    return totalamount;
  },
  subTotalAfterTax(state, getters) {
    let price = getters.subTotalPrice;
    let purchase_tax = state.purchase_tax;
    let after_tax = (price * purchase_tax) / 100;
    return parseFloat(after_tax);
  },
  invoiceSubTotalAfterTax(state, getters) {
    let price = getters.invoiceSubTotalPrice;
    let invoice_tax = state.invoice_tax;
    let after_tax = (price * invoice_tax) / 100;
    return parseFloat(after_tax);
  },
  subTotalAfterDiscount(state, getters) {
    let price = getters.subTotalPrice;
    let purchase_discount = state.purchase_discount;
    let after_discount = parseFloat(price - purchase_discount);
    return after_discount;
  },
  invoiceSubTotalAfterDiscount(state, getters) {
    let price = getters.invoiceSubTotalPrice;
    let invoice_discount = state.invoice_discount;
    let after_discount = parseFloat(price - invoice_discount);
    return after_discount;
  },
  subTotalPrice(state, getters) {
    let items = getters.getPurchaseItems;
    let price = 0;
    if (items && items.length) {
      items.forEach(item => {
        price += Number(item.subtotal);
      });
    }
    return price;
  },
  invoiceTotalPrice(state, getters) {
    let price = getters.invoiceSubTotalPrice;
    let invoice_discount = state.invoice_discount;
    let invoice_tax = state.invoice_tax;
    let invoice_discount_percentage = (price * invoice_tax) / 100;
    let invoice_after_tax = price + invoice_discount_percentage;
    let invoice_after_discount = invoice_after_tax - invoice_discount;
    let invoice_total_amount = parseFloat(invoice_after_discount);
    return invoice_total_amount;
  },
  invoiceSubTotalPrice(state, getters) {
    let sitems = getters.getInvoiceItems;
    let sprice = 0;
    if (sitems && sitems.length) {
      sitems.forEach(item => {
        sprice += Number(item.subtotal);
      });
    }
    return sprice;
  }
};

export const mutations = {
  SET_PURCHASE_PRODUCTS(state, payload) {
    state.purchaseItems = payload;
  },

  SET_INVOICE_PRODUCTS(state, payload) {
    state.invoiceItems = payload;
  },


  ADD_PURCHASE_ITEMS(state, payload) {
    let items = state.purchaseItems;
    if (items) {
      items.push(payload);
    } else {
      state.purchaseItems = [payload];
    }
  },
  ADD_INVOICE_ITEMS(state, payload) {
    let items = state.invoiceItems;
    if (items) {
      items.push(payload);
    } else {
      state.invoiceItems = [payload];
    }
  },
  ADD_TRANSFER_ITEMS(state, payload) {
    let items = state.transferItems;
    if (items) {
      items.push(payload);
    } else {
      state.transferItems = [payload];
    }
  },
  REMOVE_PRODUCT(state, payload) {
    let items = state.purchaseItems;
    if (items) {
      let product = items.find(product => {
        return product.id == payload.id;
      });

      if (product) {
        let index = items.indexOf(product);
        items = items.splice(index, 1);
      }
    }
  },

  REMOVE_INVOICE_PRODUCT(state, payload) {
    let items = state.invoiceItems;
    if (items) {
      let product = items.find(product => {
        return product.id == payload.id;
      });

      if (product) {
        let index = items.indexOf(product);
        items = items.splice(index, 1);
      }
    }
  },
  SET_PURCHASE_DISCOUNT(state, payload) {
    state.purchase_discount = payload;
  },
  SET_PURCHASE_TAX(state, payload) {
    state.purchase_tax = payload;
  },

  SET_INVOICE_DISCOUNT(state, payload) {
    state.invoice_discount = payload;
  },

  SET_INVOICE_TAX(state, payload) {
    state.invoice_tax = payload;
  },
};

export const actions = {
  addItemToPurchase(
    { commit },
    {
      name,
      id,
      purchase_quantity,
      price,
      discount,
      tax
    }
  )
  {
    let item = {
      name: name,
      id: id,
      purchase_quantity: purchase_quantity,
      price: price,
      discount: discount,
      tax: tax,
      subtotal: parseFloat(price) + parseFloat(tax * price) / 100
    };
    commit("ADD_PURCHASE_ITEMS", item);
  },

  // adding invoice item start from here
  addItemToInvoice(
    { commit },
    {
      name,
      id,
      invoice_quantity,
      price,
      discount,
      tax,
      category_type
    }
  )
  {
    let item = {
      name: name,
      id: id,
      invoice_quantity: invoice_quantity,
      price: price,
      discount: discount,
      tax: tax,
      category_type: category_type,
      subtotal: parseFloat(price) + parseFloat(tax * price) / 100
    };

    commit("ADD_INVOICE_ITEMS", item);
  },
  // adding invoice item end here



  updateInvoiceItem({ commit, getters }, payload) {
    let invoiceItems = getters.getInvoiceItems;
    if (payload.type == "qtychange") {
      if (invoiceItems) {
        let index = payload.index;
        invoiceItems[index].invoice_quantity = parseFloat(payload.invoice_quantity);
        invoiceItems[index].subtotal = parseFloat(invoiceItems[index].price * invoiceItems[index].invoice_quantity);
        commit("SET_INVOICE_PRODUCTS", invoiceItems);
      }
    }
    if (payload.type == "pricechange") {
      if (invoiceItems) {
        let index = payload.index;
        invoiceItems[index].price = parseFloat(payload.price);
        invoiceItems[index].subtotal = parseFloat(payload.price * invoiceItems[index].invoice_quantity)
        commit("SET_INVOICE_PRODUCTS", invoiceItems);
      }
    }
    if (payload.type == "invoiceTax") {
      if (invoiceItems) {
        commit("SET_INVOICE_TAX", payload.invoice_tax);
      }
    }
    if (payload.type == "invoiceDiscount") {
      if (invoiceItems) {
        commit("SET_INVOICE_DISCOUNT", payload.invoice_discount);
      }
    }
  },
  //purchase

  updateCartItem({ commit, getters }, payload) {
    let purchaseItems = getters.getPurchaseItems;

    if (payload.type == "pricechange") {
      if (purchaseItems) {
        let index = payload.index;
        purchaseItems[index].price = parseFloat(payload.price);
        purchaseItems[index].subtotal = parseFloat(payload.price * purchaseItems[index].purchase_quantity)
        commit("SET_PURCHASE_PRODUCTS", purchaseItems);
      }
    }
    if (payload.type == "qtychange") {
      if (purchaseItems) {
        let index = payload.index;
        purchaseItems[index].purchase_quantity = parseFloat(payload.purchase_quantity);
        purchaseItems[index].subtotal = parseFloat(purchaseItems[index].price * purchaseItems[index].purchase_quantity);

        commit("SET_PURCHASE_PRODUCTS", purchaseItems);
      }
    }
    if (payload.type == "discountchange") {
      if (purchaseItems) {
        let index = payload.index;
        purchaseItems[index].discount = payload.discount;
        purchaseItems[index].subtotal =
          purchaseItems[index].purchase_quantity *
            purchaseItems[index].purchase_price +
          parseInt(
            purchaseItems[index].tax *
              purchaseItems[index].purchase_price *
              purchaseItems[index].purchase_quantity
          ) /
            100 -
          payload.discount;

        commit("SET_PURCHASE_PRODUCTS", purchaseItems);
      }
    }
    if (payload.type == "taxchange") {
      if (purchaseItems) {
        let index = payload.index;
        purchaseItems[index].tax = payload.tax;
        purchaseItems[index].subtotal =
          purchaseItems[index].purchase_quantity *
            purchaseItems[index].purchase_price +
          parseInt(
            payload.tax *
              purchaseItems[index].purchase_price *
              purchaseItems[index].purchase_quantity
          ) /
            100 -
          purchaseItems[index].discount;

        commit("SET_PURCHASE_PRODUCTS", purchaseItems);
      }
    }
    if (payload.type == "purchasetax") {
      if (purchaseItems) {
        commit("SET_PURCHASE_TAX", payload.tax);
      }
    }
    if (payload.type == "purchasediscount") {
      if (purchaseItems) {
        commit("SET_PURCHASE_DISCOUNT", payload.discount);
      }
    }
  },

  updatePrice({ commit, getters }, { product, price, index }) {
    let purchaseItems = getters.getpurchaseItems;
    if (purchaseItems) {
      purchaseItems[index].price = price / 40;
      purchaseItems[index].total = (price / 40) * purchaseItems[index].qty;
      commit("SET_PURCHASE_PRODUCTS", purchaseItems);
    }
  },
  removeCartItem({ commit, getters }, { product, index }) {
    let purchaseItems = getters.getPurchaseItems;
    if (purchaseItems) {
      purchaseItems.splice(index, 1);
      commit("REMOVE_PRODUCT", purchaseItems);
    }
  },

  removeInvoiceCartItem({ commit, getters }, { product, index }) {
    let invoiceItems = getters.getInvoiceItems;
    if (invoiceItems) {
      invoiceItems.splice(index, 1);
      commit("REMOVE_INVOICE_PRODUCT", invoiceItems);
    }
  }


};
