<template>
    <div>
        <el-card>
            <el-table :data="orderData" stripe style="width: 100%" border>
                <el-table-column
                    prop="oId"
                    label="Appointment No."
                    width="140px"
                ></el-table-column>
                <el-table-column
                    prop="pId"
                    label="My ID"
                    width="90px"
                ></el-table-column>
                <el-table-column
                    prop="pName"
                    label="Name"
                    width="100px"
                ></el-table-column>
                <el-table-column
                    prop="dId"
                    label="Doctor ID"
                    width="100px"
                ></el-table-column>
                <el-table-column
                    prop="dName"
                    label="Doctor Name"
                    width="120px"
                ></el-table-column>

                <el-table-column
                    prop="oStart"
                    label="Appointment Time"
                    width="195px"
                ></el-table-column>
                <el-table-column
                    prop="oEnd"
                    label="End Time"
                    width="185px"
                ></el-table-column>
                <el-table-column
                    prop="oTotalPrice"
                    label="Fee (NZD)"
                    width="100px"
                ></el-table-column>
                <el-table-column
                    prop="oPriceState"
                    label="Payment"
                    width="150"
                >
                    <template slot-scope="scope">
                        <el-tag
                            type="success"
                            v-if="scope.row.oPriceState === 1"
                            >Paid</el-tag
                        >
                        <!-- <el-tag type="danger" v-if="scope.row.oPriceState === 0 && scope.row.oState === 1">Unpaid</el-tag> -->
                        <el-button
                            type="warning"
                            style="font-size: 14px"
                            v-if="
                                scope.row.oPriceState === 0 &&
                                scope.row.oState === 1
                            "
                            @click="priceClick(scope.row.oId, scope.row.dId)"
                        >
                            Pay</el-button
                        >
                    </template>
                </el-table-column>
                <el-table-column prop="oState" label="Status" width="100px">
                    <template slot-scope="scope">
                        <el-tag
                            type="success"
                            v-if="
                                scope.row.oState === 1 &&
                                scope.row.oPriceState === 1
                            "
                            >Completed</el-tag
                        >
                        <el-tag
                            type="danger"
                            v-if="
                                scope.row.oState === 0 && scope.row.oState === 0
                            "
                            >Incomplete</el-tag
                        >
                    </template>
                </el-table-column>
                <el-table-column label="Report" fixed="right" width="150">
                    <template slot-scope="scope">
                        <el-button
                            type="success"
                            style="font-size: 14px"
                            @click="seeReport(scope.row.oId)"
                            v-if="
                                scope.row.oState === 1 &&
                                scope.row.oPriceState === 1
                            "
                            > View</el-button
                        >
                    </template>
                </el-table-column>
            </el-table>
        </el-card>
        <!-- Rating dialog -->
        <el-dialog title="Rating" :visible.sync="starVisible">
            <div>
                <h3>
                    Rate doctor {{ dName }} (ID: {{ dId }})
                </h3>
            </div>
            <div>
                <el-rate v-model="star" show-text> </el-rate>
            </div>
            <div slot="footer" class="dialog-footer">
                <el-button @click="starVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="starClick" style="font-size: 18px;"> Confirm</el-button>
            </div>
        </el-dialog>
    </div>
</template>
<script>
import request from "@/utils/request.js";
import jwtDecode from "jwt-decode";
import { getToken } from "@/utils/storage.js";
export default {
    name: "MyOrder",
    data() {
        return {
            userId: 1,
            orderData: [],
            star: 5,
            starVisible: false,
            dId: 1,
            dName: "",
        };
    },
    methods: {
        // Confirm rating
        starClick() {
            console.log(this.star);
            console.log(this.dId);
            request
                .get("hospital/doctor/updateStar", {
                    params: {
                        dId: this.dId,
                        dStar: this.star,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Rating failed");
                    this.$message.success("Thank you for your rating");
                    this.starVisible = false;
                });
        },
        // View report
        seeReport(id) {
            window.location.href = "/hospital/patient/pdf?oId=" + id;
        },
        // Pay button
        priceClick(oId, dId) {
            request
                .get("hospital/order/updatePrice", {
                    params: {
                        oId: oId,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200) {
                        this.$message.error("Failed to load data");
                        return;
                    }
                    this.$message.success("Appointment " + oId + " paid successfully");
                    request
                        .get("hospital/admin/findDoctor", {
                            params: {
                                dId: dId,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error("Failed to load data");
                            this.dId = res.data.data.dId;
                            this.dName = res.data.data.dName;
                        });
                    this.starVisible = true;
                    this.requestOrder();
                });
        },
        // Request appointment data
        requestOrder() {
            request
                .get("hospital/patient/findOrderByPid", {
                    params: {
                        pId: this.userId,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        this.$message.error("Failed to load data");
                    this.orderData = res.data.data;
                    //this.orderData.dSection = res.data.data.map(item => item.doctor.dSection);
                    //console.log(res.data.data.map(item => item.doctor.dSection));
                    console.log(this.orderData.oId);
                    console.log(this.orderData.pName);
                    console.log(res);
                });
        },
        // Decode token
        tokenDecode(token) {
            if (token !== null) return jwtDecode(token);
        },
    },
    created() {
        // Decode token
        //this.orderData.pName = this.tokenDecode(getToken()).pName;
        //this.orderData.pCard = this.tokenDecode(getToken()).pCard;
        this.userId = this.tokenDecode(getToken()).pId;
        console.log(this.orderData.pName);
        //this.orderData.pName = "dasda"
        this.requestOrder();
    },
};
</script>
<style lang="scss" scoped>
.el-dialog div {
    text-align: center;
    margin-bottom: 8px;
}
</style>
