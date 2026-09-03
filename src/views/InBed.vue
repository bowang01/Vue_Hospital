<template>
    <div>
        <el-card>
            <!-- Search bar -->
            <el-row type="flex">
                <el-col :span="6">
                    <el-input v-model="query" placeholder="Search by patient ID">
                        <el-button
                            slot="append"
                            icon="iconfont icon-r-find"
                            @click="requestOrders"
                        ></el-button>
                    </el-input>
                </el-col>
            </el-row>
            <el-table :data="orderData" stripe border>
                <el-table-column label="Appointment No." prop="oId"></el-table-column>
                <el-table-column label="Patient ID" prop="pId"></el-table-column>
                <el-table-column label="Doctor ID" prop="dId"></el-table-column>
                <!-- <el-table-column label="Doctor Name" prop="dName"></el-table-column> -->
                <el-table-column
                    label="Appointment Time"
                    prop="oStart"
                ></el-table-column>
                <el-table-column label="End Time" prop="oEnd"></el-table-column>
                <el-table-column label="Status" prop="oState">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.oState === 1" type="success"
                            >Completed</el-tag
                        >
                        <el-tag v-if="scope.row.oState === 0" type="danger"
                            >Incomplete</el-tag
                        >
                    </template>
                </el-table-column>
                <el-table-column label="Actions" width="230" fixed="right">
                    <template slot-scope="scope">
                        <el-button
                            type="warning"
                            style="font-size: 18px"
                            @click="BedDiag(scope.row.pId, scope.row.dId)"
                        >
                             Apply for Admission</el-button
                        >
                    </template>
                </el-table-column>
            </el-table>
            <!-- Pagination -->
            <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                background
                layout="total, sizes, prev, pager, next, jumper"
                :current-page="pageNumber"
                :page-size="size"
                :page-sizes="[1, 2, 4, 8, 16]"
                :total="total"
            >
            </el-pagination>
        </el-card>
        <!-- Admission dialog -->
        <el-dialog title="Apply for Admission" :visible.sync="BedFormVisible">
            <el-form class="findPassword" :model="bedForm">
                <el-form-item label="Patient Account" label-width="140px" prop="pId">
                    <el-input v-model="bedForm.pId" disabled></el-input>
                </el-form-item>
                <el-form-item label="Doctor Account" label-width="140px">
                    <el-input v-model="bedForm.dId" disabled></el-input>
                </el-form-item>
                <el-form-item label="Reason" label-width="140px">
                    <el-input
                        v-model="bedForm.bReason"
                        type="textarea"
                        :rows="4"
                    ></el-input>
                </el-form-item>

                <el-form-item label="Bed No." label-width="140px" prop="bId">
                    <el-select v-model="bedForm.bId">
                        <el-option
                            v-for="item in nullBed"
                            :key="item.bId"
                            :label="item.bId"
                            :value="item.bId"
                        >
                        </el-option>
                    </el-select>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="BedFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="bedClick" style="font-size: 18px;"> Confirm</el-button>
            </div>
        </el-dialog>
    </div>
</template>
<script>
import jwtDecode from "jwt-decode";
import { getToken } from "@/utils/storage.js";

import request from "@/utils/request.js";
export default {
    name: "InBed",
    data() {
        return {
            userId: 1,
            userName: "",
            pageNumber: 1,
            size: 4,
            query: "",
            total: 3,
            orderData: [],
            // Admission application dialog
            BedFormVisible: false,
            bedForm: {},
            nullBed: [],
        };
    },
    methods: {
        // Confirm bed application
        bedClick() {
            request
                .get("hospital/bed/updateBed", {
                    params: {
                        bId: this.bedForm.bId,
                        dId: this.bedForm.dId,
                        pId: this.bedForm.pId,
                        bReason: this.bedForm.bReason,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Too late, this bed is already occupied");
                    this.BedFormVisible = false;
                    this.$message.success("Admission application submitted successfully");
                    this.requestOrders();
                    console.log(res);
                });
        },

        // Request all vacant beds
        requestBeds() {
            request
                .get("hospital/bed/findNullBed")
                .then((res) => {
                    
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.nullBed = res.data.data;
                    console.log(res.data.data);
                })
                .catch((err) => {
                    console.error(err);
                });
        },
        // Open admission dialog
        BedDiag(pId, dId) {
            this.bedForm.pId = pId;
            this.bedForm.dId = dId;
            this.BedFormVisible = true;
            this.requestBeds();
        },
        // Triggered when page size changes
        handleSizeChange(size) {
            console.log(size);
            this.size = size;
            this.requestOrders();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestOrders();
        },
        // Get completed order data
        requestOrders() {
            request
                .get("hospital/order/findOrderFinish", {
                    params: {
                        dId: this.userId,
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.orderData = res.data.data.orders;
                    this.total = res.data.data.total;
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
        this.userName = this.tokenDecode(getToken()).dName;
        console.log(this.userId);
        console.log(this.userName);
        // Get order data
        this.requestOrders();
    },
};
</script>
<style lang="scss" scoped>
.el-table {
    margin-top: 20px;
    margin-bottom: 20px;
}
</style>
