<template>
    <div>
        <!-- Card -->
        <el-card>
            <!-- Search bar and add bed -->
            <el-row type="flex">
                <el-col :span="6">
                    <el-input v-model="query" placeholder="Search by patient ID">
                        <el-button
                            slot="append"
                            @click="requestBeds"
                            style="font-size: 18px"
                        > Search</el-button>
                    </el-input>
                </el-col>
                <el-col :span="6"></el-col>
                <el-col :span="6">
                    <el-button
                        type="primary"
                        style="font-size: 18px"
                        @click="addFormVisible = true"
                    > 
                        Add Bed</el-button
                    >
                </el-col>
            </el-row>
            <!-- Table -->
            <el-table :data="bedData" stripe style="width: 100%" border>
                <el-table-column label="Bed No." prop="bId"></el-table-column>
                <el-table-column label="Patient ID" prop="pId"></el-table-column>
                <el-table-column label="Doctor ID" prop="dId"></el-table-column>
                <el-table-column
                    label="Start Time"
                    prop="bStart"
                ></el-table-column>
                <el-table-column
                    label="Reason"
                    prop="bReason"
                ></el-table-column>
                <el-table-column label="Status" prop="bState">
                    <template slot-scope="scope">
                        <el-tag v-if="scope.row.bState === 1" type="danger"
                            >Occupied</el-tag
                        >
                        <el-tag v-if="scope.row.bState === 0" type="success"
                            >Vacant</el-tag
                        >
                    </template>
                </el-table-column>

                <el-table-column label="Actions" width="260" fixed="right">
                    <template slot-scope="scope">
                        <el-button
                            style="font-size: 18px"
                            type="success"
                            @click="emptyDialog(scope.row.bId)"
                        > Clear</el-button>
                        <el-button
                            style="font-size: 18px"
                            type="danger"
                            @click="deleteDialog(scope.row.bId)"
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

        <!-- Add bed dialog -->
        <el-dialog title="Add Bed" :visible.sync="addFormVisible">
            <el-form :model="addForm" :rules="rules" ref="ruleForm">
                <el-form-item label="Bed No." prop="bId" label-width="110px">
                    <el-input v-model.number="addForm.bId"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="addFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="addBed('ruleForm')"
                    style="font-size: 18px;"> Confirm</el-button
                >
            </div>
        </el-dialog>
    </div>
</template>
<script>
import request from "@/utils/request.js";

export default {
    name: "CheckList",
    data() {
        return {
            pageNumber: 1,
            size: 8,
            query: "",
            bedData: [],
            total: 3,
            addFormVisible: false,
            addForm: {},
            rules: {
                bId: [
                    { required: true, message: "Please enter bed number", trigger: "blur" },
                    {
                        type: "number",
                        message: "Bed number must be a number",
                        trigger: "blur",
                    },
                ],
            },
        };
    },
    methods: {
        // Clear bed
        emptyBed(id) {
            request
                .get("hospital/bed/emptyBed", {
                    params: {
                        bId: id,
                    },
                })
                .then((res) => {
                    this.requestBeds();
                    console.log(res);
                });
        },
        // Clear dialog
        emptyDialog(id) {
            this.$confirm("Clear this bed?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    this.emptyBed(id);
                    this.$message({
                        type: "success",
                        message: "Cleared successfully!",
                    });
                })
                .catch(() => {
                    this.$message({
                        type: "info",
                        message: "Clear cancelled",
                    });
                });
        },

        // Delete bed
        deleteBed(id) {
            request
                .get("hospital/bed/deleteBed", {
                    params: {
                        bId: id,
                    },
                })
                .then((res) => {
                    this.requestBeds();
                    console.log(res);
                });
        },
        // Delete dialog
        deleteDialog(id) {
            this.$confirm("Delete this bed?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    this.deleteBed(id);
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
        // Confirm add
        addBed(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/bed/addBed", {
                            params: {
                                bId: this.addForm.bId,
                                pId: -1,
                                dId: -1,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error("Bed number invalid or occupied!");
                            this.addFormVisible = false;
                            this.requestBeds();
                            this.$message.success("Bed added successfully!");
                            console.log(res);
                        });
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
        // Triggered when page size changes
        handleSizeChange(size) {
            this.size = size;
            this.requestBeds();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestBeds();
        },
        // Load bed list
        requestBeds() {
            request
                .get("hospital/bed/findAllBeds", {
                    params: {
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
                    this.bedData = res.data.data.beds;
                    this.total = res.data.data.total;
                    
                });
        },
    },
    created() {
        this.requestBeds();
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
