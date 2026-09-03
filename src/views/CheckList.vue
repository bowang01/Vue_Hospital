<template>
    <div>
        <!-- Card -->
        <el-card>
            <!-- Search bar and add exam -->
            <el-row type="flex">
                <el-col :span="6">
                    <el-input v-model="query" placeholder="Search by name">
                        <el-button
                            slot="append"
                            style="font-size: 18px;"
                            @click="requestChecks"
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
                        Add Exam</el-button
                    >
                </el-col>
            </el-row>
            <!-- Table -->
            <el-table :data="checkData" stripe style="width: 100%" border>
                <el-table-column label="ID" prop="chId"></el-table-column>
                <el-table-column label="Item" prop="chName"></el-table-column>
                <el-table-column
                    label="Fee (CNY)"
                    prop="chPrice"
                ></el-table-column>
                <el-table-column label="Actions" width="290" fixed="right">
                    <template slot-scope="scope">
                        <el-button
                            style="font-size: 18px"
                            type="success"
                            @click="modifyDialog(scope.row.chId)"
                        > Edit</el-button>
                        <el-button
                            style="font-size: 18px"
                            type="danger"
                            @click="deleteDialog(scope.row.chId)"
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

        <!-- Add exam dialog -->
        <el-dialog title="Add Exam" :visible.sync="addFormVisible">
            <el-form :model="addForm" :rules="rules" ref="ruleForm">
                <el-form-item label="ID" prop="chId" label-width="110px">
                    <el-input v-model.number="addForm.chId"></el-input>
                </el-form-item>
                <el-form-item label="Name" prop="chName" label-width="110px">
                    <el-input v-model="addForm.chName"></el-input>
                </el-form-item>
                <el-form-item label="Price" prop="chPrice" label-width="110px">
                    <el-input v-model="addForm.chPrice"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="addFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="addCheck('ruleForm')"
                    style="font-size: 18px;"> Confirm</el-button
                >
            </div>
        </el-dialog>

        <!-- Edit exam dialog -->
        <el-dialog title="Edit Exam" :visible.sync="modifyFormVisible">
            <el-form :model="modifyForm" :rules="rules" ref="ruleForm">
                <el-form-item label="ID" prop="chId" label-width="110px">
                    <el-input
                        v-model.number="modifyForm.chId"
                        disabled
                    ></el-input>
                </el-form-item>
                <el-form-item label="Name" prop="chName" label-width="110px">
                    <el-input v-model="modifyForm.chName"></el-input>
                </el-form-item>
                <el-form-item label="Price" prop="chPrice" label-width="110px">
                    <el-input v-model="modifyForm.chPrice"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="modifyFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="modifyCheck('ruleForm')"
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
            checkData: [],
            total: 3,
            addFormVisible: false,
            addForm: {},
            rules: {
                chId: [
                    { required: true, message: "Please enter ID", trigger: "blur" },
                    {
                        type: "number",
                        message: "ID must be a number",
                        trigger: "blur",
                    },
                ],
                chName: [
                    { required: true, message: "Please enter name", trigger: "blur" },
                    {
                        min: 1,
                        max: 50,
                        message: "Name must be 1 to 50 characters",
                        trigger: "blur",
                    },
                ],
                chPrice: [
                    { required: true, message: "Please enter unit price", trigger: "blur" },
                ],
            },
            modifyFormVisible: false,
            modifyForm: {},
        };
    },
    methods: {
        // Submit edited exam
        modifyCheck(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/check/modifyCheck", {
                            params: {
                                chId: this.modifyForm.chId,
                                chName: this.modifyForm.chName,
                                chPrice: this.modifyForm.chPrice,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error("Failed to update!");
                            this.modifyFormVisible = false;
                            this.requestChecks();
                            this.$message.success("Exam updated successfully!");
                            console.log(res);
                        });
                } else {
                    console.log("error submit!!");
                    return false;
                }
            });
        },
        // Open edit dialog
        modifyDialog(id) {
            request
                .get("hospital/check/findCheck", {
                    params: {
                        chId: id,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        return this.$message.error("Failed to load data");
                    this.modifyForm = res.data.data;
                    this.modifyFormVisible = true;
                    console.log(res);
                });
        },
        // Delete exam
        deleteCheck(id) {
            request
                .get("hospital/check/deleteCheck", {
                    params: {
                        chId: id,
                    },
                })
                .then((res) => {
                    this.requestChecks();
                    console.log(res);
                });
        },
        // Delete dialog
        deleteDialog(id) {
            this.$confirm("Delete this exam?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    this.deleteCheck(id);
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
        addCheck(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/check/addCheck", {
                            params: {
                                chId: this.addForm.chId,
                                chName: this.addForm.chName,
                                chPrice: this.addForm.chPrice,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error(
                                    "Invalid or occupied ID!"
                                );
                            this.addFormVisible = false;
                            this.requestChecks();
                            this.$message.success("Exam added successfully!");
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
            this.requestChecks();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestChecks();
        },
        // Load exam list
        requestChecks() {
            request
                .get("hospital/check/findAllChecks", {
                    params: {
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
                    this.checkData = res.data.data.checks;
                    this.total = res.data.data.total;
                    
                });
        },
    },
    created() {
        this.requestChecks();
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
