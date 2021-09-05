<template>
  <v-dialog v-model="dialog" persistent max-width="600px">
    <v-card>
      <v-card-title>
        {{ $t("add_payment") }}
        <v-spacer/>
        <v-icon aria-label="Close" @click="closedialog"> mdi-close</v-icon>
      </v-card-title>
      <v-divider></v-divider>
      <v-card-text>
        <v-container>
          <div class="infobox">
            <p>{{ $t("payable_amount") }}</p>
            <b>{{ payable_amount }}</b>
          </div>
          <br/>
          <v-form ref="form" v-model="valid" lazy-validation>
            <v-row no-gutters>
              <v-col cols="12" sm="6" md="6">
                <span>{{ $t("select_payment_method") }}</span>
                <v-select
                  v-model="form.payment_method"
                  :items="methods"
                  item-text="name"
                  item-value="id"
                  dense
                  outlined
                ></v-select>
              </v-col>
              <v-row v-show="form.payment_method =='Bank Transfer'">
                <v-col cols="12" sm="6" md="6">
                  <span>{{ $t("bank_name") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    v-model="form.bank_name"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6" md="6">
                  <span>{{ $t("account_no") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    v-model="form.account_no"
                  ></v-text-field>
                </v-col>
              </v-row>
              <v-col v-show="form.payment_method == 'Card'" cols="12" sm="6" md="6">
                <span>{{ $t("card_no") }}</span>
                <v-text-field
                  outlined
                  dense
                  required
                  v-model="form.card_no"
                ></v-text-field>
              </v-col>
              <v-row>
                <v-col cols="12" sm="6" md="6">
                  <span>{{ $t("paying_amount") }}</span>
                  <v-text-field
                    outlined
                    dense
                    required
                    :rules="paymentamountRules"
                    v-model="form.payment_amount"
                  ></v-text-field>
                </v-col>
                <v-col cols="12" sm="6" md="6">
                  <span>{{ $t("payment_date") }}</span>
                  <date-picker
                    v-model="form.payment_date"
                    type="date"
                    value-type="format"
                  ></date-picker>
                </v-col>
              </v-row>

              <v-col cols="12" sm="6" md="12">
                <span>{{ $t("payment_note") }}</span>
                <v-textarea
                  rows="3"
                  outlined
                  dense
                  required
                  v-model="form.payment_note"
                ></v-textarea>
              </v-col>
            </v-row>
            <v-row no-gutters>
              <v-col cols="12">
                <v-btn
                  class="float-right"
                  dark
                  color="success"
                  :loading="isLoading"
                  @click="submitForm"
                >
                  Submit
                </v-btn>
              </v-col>
            </v-row>
          </v-form>
        </v-container>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script>
import DatePicker from "vue2-datepicker";
import "vue2-datepicker/index.css";
export default {
  props: ["item", "type"],
  name: "addPayment",
  components: {DatePicker},
  data() {
    return {
      success:false,
      isLoading: false,
      valid: true,
      paymentamountRules: [
        (v) => !!v || "Payment amount is required",
        (v) =>
          v <= this.item.due_amount ||
          "Paying Amount must be less than due amount",
      ],
      form: {
        payment_date: new Date().toISOString().substr(0, 10),
        payment_amount: "",
        payment_method: "Cash",
        payment_note: "",
        card_no: "",
        bank_name: "",
        account_no: ""
      },
      payable_amount:"",
      methods: ["Cash", "Card", "Bank Transfer"],
    };
  },
  computed: {
    dialog() {
      return this.$store.getters.modaltype == "addpayment"
        ? this.$store.getters.modal
        : false;
    },
    modaltype() {
      return this.$store.getters.modaltype;
    },
  },
  mounted() {
    console.log(this.payable_amount)
  },

  methods: {
    closedialog() {
      this.$store.commit("SET_MODAL", {type: "", status: false});
    },
    async submitForm() {
      if (this.type == "purchase") {
        if (this.$refs.form.validate()) {
          this.isLoading = true;
          await this.$axios
            .patch(`purchase/addpayment/${this.item.id}`, this.form)
            .then((res) => {
              this.isLoading = false;
              this.$refs.form.reset();
              let data = {
                alert: true,
                message: "Payment Added Successfully",
                type: "success",
              };
              this.$store.commit("SET_ALERT", data);
              this.$store.commit("SET_MODAL", false);
              this.$emit("refresh");
            });
        }
      } else if (this.type == "sell") {
        if (this.$refs.form.validate()) {
          this.isLoading = true;
          await this.$axios
            .patch(`sell/addpayment/${this.item.id}`, this.form)
            .then((res) => {
              this.isLoading = false;
              this.$refs.form.reset();
              let data = {
                alert: true,
                message: "Payment Added Successfully",
                type: "success",
              };
              this.$store.commit("SET_ALERT", data);
              this.$store.commit("SET_MODAL", false);
              this.$emit("refresh");
              this.success=true;
              this.$emit('paymentSuccess', this.success)
            });
        }
      }
    },
  },
  watch: {
    item(val) {
      this.form.payment_amount = val.due_amount;
      this.payable_amount = this.form.payment_amount;
    },
  },
};
</script>

<style scoped>
.infobox {
  background: #eff0ff;
  width: 100%;
  height: 80px;
  padding: 16px;
}

.infobox p {
  color: #000;
}

.infobox b {
  color: #000;
}

span {
  color: #000;
}
</style>
