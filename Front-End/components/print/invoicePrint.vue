<template>
  <v-container>
    <div align="center" justify="center">
    </div>
    <div style="text-align: center;" class="mt-n3">
      <h3>Smart garage</h3>
    </div>
    <br/><br/>
    <v-row justify="center" class="">
      <v-col cols="12" sm="12" md="12">
        <v-card class="mb-70" flat>
          <v-card-title class="justify-center">
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
<!--    <br/>-->
<!--    <br/>-->
<!--    <div id="print-footer1"></div>-->
  </v-container>
</template>
<script>
export default {
  props: ["headers", "invoice","invoiceItems"],
  name: "test",
  data() {
    return {
      hide: false,
      theaders: this.headers
    };
  },
  computed: {
    theads() {
      return this.theaders.filter(e => (e.value !== "actions") && (e.value !=="serial_no"));
    }
  },
  mounted() {
  },
  methods: {},
  watch: {
    items(val) {
      this.invoice = val;
    }
  }
};
</script>

<style scoped>
.logoname {
  margin-bottom: 10px;
}
</style>
