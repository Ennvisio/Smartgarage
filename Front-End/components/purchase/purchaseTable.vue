<template>
  <v-row class="mb-10">
    <v-col cols="12">
      <v-data-table
        :headers="headers"
        :items="purchaseItems"
        class="elevation-1"
        fixed-header
        :hide-default-footer="true"
        flat
      >
        <template v-slot:[`item.purchase_quantity`]="{ item }">
          <v-text-field
            dense
            outlined
            class="shrink"
            type="number"
            :value="item.purchase_quantity"
            @keyup="qtyChange($event.target.value, purchaseItems.indexOf(item))"
          ></v-text-field>
        </template>
        <template v-slot:[`item.price`]="{ item }">
          <v-text-field
            dense
            outlined
            class="shrink"
            type="number"
            :value="item.price"
            @keyup="
              priceChange($event.target.value, purchaseItems.indexOf(item))
            "
          ></v-text-field>
        </template>
        <template v-slot:[`item.action`]="{ item }">
          <v-icon small @click="removeItem(item, purchaseItems.indexOf(item))">
            mdi-delete
          </v-icon>
        </template>
      </v-data-table>
    </v-col>
  </v-row>
</template>
<script>
export default {
  name: "purchaseTbale",
  props:["flag"],
  data() {
    return {
      headers: [
        { text: this.$t("name"), value: "name" },
        { text: this.$t("quantity"), value: "purchase_quantity" },
        { text: this.$t("price"), value: "price" },
        { text: this.$t("sub_total"), value: "subtotal" },
        { text: this.$t("action"), value: "action" }
      ]
    };
  },
  computed: {
    purchaseItems() {
      let products = this.$store.getters["product/getPurchaseItems"];
      return products;
    }
  },
  async asyncData({ params, axios }) {},
  mounted() {},
  methods: {
    qtyChange(val, index) {
      this.$store.dispatch("product/updateCartItem", {
        purchase_quantity: val,
        index: index,
        type: "qtychange"
      });
    },
    priceChange(val, index) {
      this.$store.dispatch("product/updateCartItem", {
        // purchase_price: parseInt(val),
        price: parseInt(val),
        index: index,
        type: "pricechange"
      });
    },

    removeItem(val,index){
      this.$store.commit("product/REMOVE_PRODUCT", {
        id: val.id,
        index: index,
      });
    }
  }
};
</script>

<style scoped>
.v-text-field {
  width: 100px;
  margin-top: 10px !important;
}
</style>
