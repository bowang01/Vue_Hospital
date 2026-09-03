<template>
    <div style="width: 100%;margin-top: -10px">
        <el-card shadow="hover">
            <table>
                <tr>
                    <td style="">Name:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dName"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Account:</td>
                    <td>
                        <el-input disabled v-model="doctorData.dId"></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Gender:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dGender"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dPhone"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>ID Number:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dCard"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dEmail"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Title:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dPost"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Department:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dSection"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Fee:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dPrice"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Rating:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dAvgStar"
                        ></el-input>
                    </td>
                </tr>
                <tr>
                    <td>Bio:</td>
                    <td>
                        <el-input
                            disabled
                            v-model="doctorData.dIntroduction"
                            type="textarea"
                            :rows="4"
                        ></el-input>
                    </td>
                </tr>
            </table>
        </el-card>
    </div>
</template>
<script>
import jwtDecode from "jwt-decode";
import { getToken } from "@/utils/storage.js";
import request from "@/utils/request.js";
export default {
    name: "DoctorCard",
    data() {
        return {
            userId: "",
            doctorData: {},
        };
    },
    methods: {
        // Request doctor data
        requestDoctor() {
            request
                .get("hospital/admin/findDoctor", {
                    params: {
                        dId: this.userId,
                    },
                })
                .then((res) => {
                    if (res.data.status != 200)
                        return this.$message.error("Failed to load data");
                    this.doctorData = res.data.data;
                });
        },
        // Decode token
        tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
    },
    created() {
        // Decode token
        this.userId = this.tokenDecode(getToken()).dId;
        this.requestDoctor();
        console.log(this.userId);
    },
};
</script>
<style lang="scss" scope>
td, th {
  white-space: nowrap;
  padding: 10px;
}
td:first-child {
  min-width: 130px;
  width: 140px;
  text-align: right;
  color: #606266;
}
</style>
