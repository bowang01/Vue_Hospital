<template>
    <div>
        <!-- Breadcrumb -->
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item :to="{ path: '/sectionIndex' }"
                >Back to Departments</el-breadcrumb-item
            >
            <el-breadcrumb-item>{{ section }}</el-breadcrumb-item>
        </el-breadcrumb>
        <el-input
            v-model="query"
            placeholder="Search by name"
            class="doctorInput"
        >
            <el-button
                slot="append"
                icon="el-icon-search"
                @click="requestDoctors"
            ></el-button>
        </el-input>
        <el-table :data="doctorData" border>
            <el-table-column
                label="Account"
                prop="dId"
                v-model="doctorData.dId"
            ></el-table-column>
            <el-table-column
                label="Name"
                prop="dName"
                v-model="doctorData.dName"
            ></el-table-column>
            <el-table-column
                label="Gender"
                prop="dGender"
                v-model="doctorData.dGender"
            ></el-table-column>
            <el-table-column
                label="Title"
                prop="dPost"
                v-model="doctorData.dPost"
            ></el-table-column>
            <el-table-column
                label="Department"
                prop="dSection"
                v-model="doctorData.dSection"
            ></el-table-column>
            <el-table-column label="Actions" prop="dSection" width="180" fixed="right">
                <template slot-scope="scope">
                    <el-button
                        v-if="scope.row.arrangeId == null"
                        type="success"
                        style="font-size: 18px"
                        @click="arrangeClick(scope.row.dId)"
                    >
                        Schedule</el-button
                    >
                    <el-button
                        v-if="scope.row.arrangeId != null"
                        type="danger"
                        style="font-size: 18px"
                        @click="deleteArrange(scope.row.arrangeId)"
                    >
                        Unschedule</el-button
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
    </div>
</template>
<script>
import request from "@/utils/request.js";

export default {
    name: "ArrangeDoctor",
    data() {
        return {
            section: this.$route.query.section,
            doctorData: [],
            total: 3,
            pageNumber: 1,
            size: 8,
            query: "",
        };
    },
    methods: {
        // Schedule click
        arrangeClick(dId) {
            request
                .get("hospital/arrange/addArrange", {
                    params: {
                        arId: dId + sessionStorage.getItem("arrangeDate"),
                        arTime: sessionStorage.getItem("arrangeDate"),
                        dId: dId,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Already scheduled");
                    this.$message.success("Scheduled successfully!");
                    this.requestDoctors();
                })
                .catch((e) => {
                    if (e.response.data == undefined) {
                        this.$message.error(e);
                    } else {
                        this.$message.error(e.response.data);
                    }
                });
        },
        deleteArrange(arrangeId) {
            request
                .get("hospital/arrange/deleteArrange", {
                    params: {
                        arId: arrangeId,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Schedule not found");
                    this.$message.success("Schedule deleted successfully!");
                    this.requestDoctors();
                });
        },
        // Triggered when page size changes
        handleSizeChange(size) {
            this.size = size;
            this.requestDoctors();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestDoctors();
        },
        // Request doctors by department
        requestDoctors() {
            request
                .get("hospital/doctor/findDoctorBySectionPage", {
                    params: {
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                        dSection: this.section,
                        arrangeDate: sessionStorage.getItem("arrangeDate"),
                    },
                })
                .then((res) => {
                    console.log(res.data);
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.doctorData = res.data.data.doctors;
                    this.total = res.data.data.total;
                    
                });
        },
    },
    created() {
        this.requestDoctors();
    },
};
</script>
<style scope lang="scss">
.el-breadcrumb {
    margin-bottom: 10px;
}
.doctorInput {
    width: 30%;
    margin-bottom: 10px;
}
</style>
