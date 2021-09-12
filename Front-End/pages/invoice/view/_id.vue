<template>
  <v-container fluid style="min-height:700px">
    <v-row>
      <div id="printable" ref="printable" v-if="enablePrint">
        <invoice-print
          :headers="headers"
          :invoice="invoice"
          :invoiceItems="invoiceItems"
        />
      </div>
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
            <v-col
              cols="12"
              sm="6"
              md="6"
              xl="8"
              class="table-export text-right"
            >
              <v-icon
                class="printer rounded"
                color="primary"
                @click="printData"
              >
                mdi-printer
              </v-icon>
            </v-col>
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
import invoicePrint from "~/components/print/invoicePrint";
export default {
  middleware: "auth",
  head: {
    title: "Invoice Detail",
  },
  components: {invoicePrint},
  data: () => ({
    enablePrint: false,
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
  methods: {

    async printData() {
      this.enablePrint = true
      setTimeout(function () {
        var mywindow = window.open("", "PRINT");
        var is_chrome = Boolean(mywindow.chrome);
        mywindow.document.write(
          '<html><head style="padding:0; margin:0 auto"><title>Invoice Details</title>'
        );
        mywindow.document.write(
          "<style>table{width: 100%;font-size:12px;border-collapse:collapse;margin-bottom:15px; }table th{ text-transform: uppercase!important;}table th,table td{font-size: 12px;padding:5px 10px;text-align:center;border:1px solid #000;} #print-header2  {display:flex;justify-content:space-between;}#print-footer1{display:block;text-align:left}.footer-notes{padding:15px 0;font-size:12px}.footer-notes ul{list-style:none;padding-left:0;margin-bottom:0} </style>"
        );
        mywindow.document.write('</head><body style="zoom:90%">');
        mywindow.document.write(document.getElementById("printable").outerHTML);
        mywindow.document.write("</body></html>");
        if (is_chrome) {
          setTimeout(function () {
            // wait until all resources loaded
            mywindow.document.close(); // necessary for IE >= 10
            mywindow.focus(); // necessary for IE >= 10*/
            mywindow.print();
            //mywindow.close();
          }, 500);
        } else {
          mywindow.document.close(); // necessary for IE >= 10
          mywindow.focus(); // necessary for IE >= 10*/
          mywindow.print();
          //mywindow.close();
        }
        return true;
      }, 500);
    },


  },
};
</script>

<style scoped>
p, h3 {
  color: #000;
}
</style>
