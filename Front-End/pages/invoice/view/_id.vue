<template>
  <v-container fluid style="min-height:700px">
    <v-row>
      <v-col>
        <v-btn tile color="indigo" class="float-right" link :to="{name: 'invoice-list'}">
          {{ $t("Back") }}
        </v-btn>
      </v-col>
    </v-row>
    <v-row justify="center" class="">
      <v-col cols="12" sm="12" md="12">
        <v-card class="mb-70" flat>
          <v-card-title class="justify-center">
<!--           {{ $t("Invoice Details") }}-->
          </v-card-title>

          <v-card-text>
            <v-row>
              <v-col cols="12" sm="12" md="4">
                <h3>Billing To</h3>
                <p>Name: {{ this.invoice.client_name }}</p>
                <p>Phone: {{ this.invoice.client_phone }}</p>
              </v-col>

              <v-col cols="12" sm="12" md="4">
                <h3>Vehicle Details</h3>
                <p>Model: {{ this.invoiceItems[0].vehicle_name }}</p>
                <p>Registration No: {{ this.invoiceItems[0].reg_no }}</p>
                <p>Chassis No: {{ this.invoiceItems[0].chassis_no }}</p>
              </v-col>

              <v-col cols="12" sm="12" md="4">
                <h3>Invoice Information</h3>
                <p>Invoice Number: {{ this.invoice.invoice_number }}</p>
                <p>Date of Invoice: {{ this.invoice.date }}</p>
                <p>Discount: {{ this.invoice.discount }}</p>
                <p>Vat: {{ this.invoice.vat }}</p>
                <p>Total Amount: {{ this.invoice.total_amount }}</p>
                <p>Paid Amount: {{ this.invoice.paid_amount }}</p>
                <p>Due Amount: {{ this.invoice.due_amount }}</p>
              </v-col>
            </v-row>
            <v-row class="pb-4">
              <v-col cols="12" sm="12" md="12">
                <h3 class="text-center">Order Summary</h3>
                <v-data-table
                  :headers="headers"
                  :items="invoiceItems"
                  hide-default-footer
                  class="elevation-1 pb-4 mt-3"
                ></v-data-table>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  middleware: "auth",
  head: {
    title: "Invoice Detail",
  },
  data: () => ({
    isLoading: false,
    reveal: false,
    error: null,
    direction: "top right",
    invoice: [],
    invoiceItems: [],
  }),
  computed: {
    headers() {
      return [
        {
          sortable: false,
          text: this.$t("name"),
          value: "name"
        },
        {
          sortable: false,
          text: this.$t("quantity"),
          value: "invoice_quantity"
        },
        {
          sortable: false,
          text: this.$t("price"),
          value: "price"
        },
        {
          sortable: false,
          text: this.$t("total"),
          value: "subtotal"
        },

      ];
    },
    parsedDirection() {
      return this.direction.split(" ");
    },
  },
  async asyncData({params, $axios}) {
    const {data} = await $axios.get(`invoice/${params.id}`);
    return {
      invoice: data.data,
      invoiceItems: data.data.items,
    };
  },
  created() {
  },
  methods: {},
};
</script>

<style scoped>
p,h3 {
  color: #000;
}
</style>
