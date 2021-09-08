<template>
  <v-dialog v-model="dialog" persistent max-width="900px">
    <v-card>
      <v-card-title>
        {{ $t("view_payment") }}
        <v-spacer/>
        <v-icon aria-label="Close" @click="closedialog"> mdi-close</v-icon>
      </v-card-title>
      <v-divider></v-divider>
      <v-card-text>
        <v-container>
          <v-row no-gutters>
            <v-col cols="12">
              <v-data-table
                :headers="headers"
                :items="data"
                :hide-default-footer="true"
                :single-expand="singleExpand"
                show-expand
                disable-pagination
              >
                <template v-slot:top>
                </template>
                <template v-slot:expanded-item="{ headers, item }">
                  <td  v-show="item.payment_method =='Bank Transfer'"  :colspan="headers.length">
                    <p><span>  Bank Name: {{ item.bank_name }} </span> </p>
                    <v-spacer></v-spacer>
                    <p class="mt-3"> <span> Account No.: {{ item.account_no }}</span></p>
                  </td>
                  <td v-show="item.payment_method =='Card'" :colspan="headers.length">
                   <p class="mt-3">  <span> Card No.: {{ item.card_no }}</span>  </p>
                  </td>
                </template>
              </v-data-table>
            </v-col>
          </v-row>
        </v-container>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script>
export default {
  props: ["data"],
  name: "viewPayment",
  data() {
    return {
      singleExpand: false,

    };
  },
  computed: {
    headers() {
      return [
        {
          sortable: false,
          text: this.$t("payment_amount"),
          value: "payment_amount"
        },
        {
          sortable: false,
          text: this.$t("payment_method"),
          show: false,
          value: "payment_method"
        },
        {
          sortable: false,
          text: this.$t("Date"),
          value: "payment_date"
        },
        {
          text: '',
          value: 'data-table-expand'
        }
      ];
    },
    dialog() {
      return this.$store.getters.modaltype == "viewpayment"
        ? this.$store.getters.modal
        : false;
    },
    modaltype() {
      return this.$store.getters.modaltype;
    }
  },
  mounted() {
  },
  methods: {
    closedialog() {
      this.$store.commit("SET_MODAL", {type: "", status: false});
    }
  },
  watch: {}
};
</script>

<style scoped></style>
