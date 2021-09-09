<template>
  <v-container fluid>
    <v-row justify="center" class="pt-10" v-if="isEdit">
      <edit-profile
        :data="user"
        @close="isEdit = false"
        @success="getUserInfo()"
      />
    </v-row>
    <v-row justify="center" class="pt-10" v-else>
      <change-user-password :userId="userId" v-if="changePassword" />
      <v-col cols="12" sm="12" md="10">
        <v-card class="mb-70">
          <v-card-title>
            <v-row>
              <v-col cols="12" sm="12" md="6">
                <span>{{ $t("my_profile") }}</span>
              </v-col>
              <v-col cols="6" sm="6" md="3">
                <v-btn
                  depressed
                  color="success"
                  min-width="120px"
                  small
                  class="mr-2"
                  @click="isEdit = true"
                >
                  {{ $t("edit_profile") }}
                </v-btn>
              </v-col>
              <v-col cols="6" sm="6" md="3">
                <v-btn
                  depressed
                  color="indigo"
                  min-width="120px"
                  small
                  @click="editPassword"
                >
                  {{ $t("change_password") }}
                </v-btn>
              </v-col>
            </v-row>
          </v-card-title>
          <v-card-text>
            <v-row class="pl-10">
              <v-col cols="12" sm="6" md="12">
                <v-layout row>
                  <v-flex xl2 xs6 sm6 md2>
                    <v-subheader class="font-weight-bold">উপাধি</v-subheader>
                  </v-flex>
                  <v-flex xl10 xs6  sm6 md4>
                    <v-subheader>{{ user.surname }}</v-subheader>
                  </v-flex>
                  <v-flex xl2 xs6 sm6 md2>
                    <v-subheader class="font-weight-bold">নাম</v-subheader>
                  </v-flex>
                  <v-flex xl10 xs6  sm6 md4>
                    <v-subheader>{{ user.name }}</v-subheader>
                  </v-flex>
                </v-layout>
                <v-layout row>
                  <v-flex xl2 xs6 sm6 md2>
                    <v-subheader class="font-weight-bold">ইমেইল</v-subheader>
                  </v-flex>
                  <v-flex xl10 xs6 sm6 md4>
                    <v-subheader>{{ user.email }}</v-subheader>
                  </v-flex>
                  <v-flex xl2 xs6 sm6 md2>
                    <v-subheader class="font-weight-bold">ইউজারনেম</v-subheader>
                  </v-flex>
                  <v-flex xl10 xs6 sm6 md4>
                    <v-subheader>{{ user.username }}</v-subheader>
                  </v-flex>
                </v-layout>
                <v-layout row>
                </v-layout>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import changeUserPassword from "~/components/user/changeUserPassword";
import changePassword from "~/components/user/changePassword";
import editProfile from "../../components/profile/edit";
export default {
  name: "userProfile",
  middleware: "auth",
  head: {
    title: "User Profile"
  },
  components: { editProfile, changeUserPassword },
  data: () => ({
    vacation: false,
    loading: false,
    changePassword: false,
    user: {},
    userId: "",
    isEdit: false,
  }),
  computed: {
  },
  async asyncData({ params, axios }) {},
  mounted() {
    this.getUserInfo();
  },
  methods: {
    editPassword(item) {
      this.changePassword = true;
      this.userId = this.$auth.user.data.id;
      this.$store.commit("SET_MODAL", { type: "changePassword", status: true });
    },
    async getUserInfo() {
      await this.$axios.get("/auth/userinfo").then(response => {
        this.user = response.data.data;
        this.isEdit = false;
      });
    },
  },
  watch: {
  }
};
</script>

<style scoped>
.v-card__title {
  background-color: #e1e8eb;
  border-bottom: 1px solid rgba(0, 0, 0, 0.125);
  margin-bottom: 10px;
}
.inline-flex {
  display: inline-flex;
}
</style>
