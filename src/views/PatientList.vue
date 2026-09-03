<template>
    <!-- Card -->
    <el-card>
        <!-- Search bar -->
        <el-row type="flex">
            <el-col :span="6">
                <el-input v-model="query" placeholder="Search by name">
                    <el-button
                        slot="append"
                        style="font-size: 18px;"
                        @click="requestPatients"
                    > Search</el-button>
                </el-input>
            </el-col>
        </el-row>
        <!-- Table -->
        <el-table :data="patientData" stripe style="width: 100%" border>
            <el-table-column prop="pId" label="Account" width="100">
            </el-table-column>
            <el-table-column prop="pName" label="Name" width="100">
            </el-table-column>
            <el-table-column prop="pGender" label="Gender" width="90">
            </el-table-column>
            <el-table-column prop="pAge" label="Age" width="80">
            </el-table-column>
            <el-table-column prop="pCard" label="ID Number"> </el-table-column>
            <el-table-column prop="pPhone" label="Phone"> </el-table-column>
            <el-table-column prop="pEmail" label="Email" width="170">
            </el-table-column>
            <el-table-column prop="pState" label="Status" width="100">
                <template slot-scope="scope">
                    <el-tag type="success" v-if="scope.row.pState === 1"
                        >Active</el-tag
                    >
                    <el-tag type="danger" v-else>Deleted</el-tag>
                </template>
            </el-table-column>
            <el-table-column label="Actions" width="160" fixed="right">
                <template slot-scope="scope">
                    <el-button
                        style="font-size: 18px"
                        type="danger"
                        @click="deleteDialog(scope.row.pId)"
                    > Delete</el-button>
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
</template>
<script>
import request from "@/utils/request.js";

export default {
    name: "PatientList",
    data() {
        return {
            pageNumber: 1,
            size: 8,
            query: "",
            patientData: [],
            total: 3,
        };
    },
    methods: {
        // Delete patient
        deletePatient(id) {
            request
                .get("hospital/admin/deletePatient", {
                    params: {
                        pId: id,
                    },
                })
                .then((res) => {
                    this.requestPatients();
                    console.log(res);
                });
        },
        // Delete dialog
        deleteDialog(id) {
            this.$confirm("Delete this patient?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    this.deletePatient(id);
                    this.$message({
                        type: "success",
                        message: "Deleted successfully!",
                    });
                })
                .catch(() => {
                    this.$message({
                        type: "info",
                        message: "Deletion cancelled",
                    });
                });
        },
        // Triggered when page size changes
        handleSizeChange(size) {
            this.size = size;
            this.requestPatients();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestPatients();
        },
        // Load patient list
        requestPatients() {
            request
                .get("hospital/admin/findAllPatients", {
                    params: {
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
                    this.patientData = res.data.data.patients;

                    this.total = res.data.data.total;
                    
                });
        },
    },
    created() {
        this.requestPatients();
    },
};
</script>
<style scoped lang="scss">
.el-table {
    margin-top: 20px;
    margin-bottom: 20px;
}
.el-form {
    margin-top: 0;
}
</style>
