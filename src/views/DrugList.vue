<template>
    <div>
        <!-- Card -->
        <el-card>
            <!-- Search bar and add drug -->
            <el-row type="flex">
                <el-col :span="6">
                    <el-input v-model="query" placeholder="Search by name">
                        <el-button
                            slot="append"
                            style="font-size: 18px;"
                            @click="requestDrugs"
                        > Search</el-button>
                    </el-input>
                </el-col>
                <el-col :span="6"></el-col>
                <el-col :span="6">
                    <el-button
                        type="primary"
                        @click="addFormVisible = true"
                        style="font-size: 18px"
                    > 
                        Add Drug</el-button
                    >
                </el-col>
            </el-row>
            <!-- Table -->
            <el-table :data="drugData" stripe border>
                <el-table-column label="ID" prop="drId" width="80"></el-table-column>
                <el-table-column label="Name" prop="drName"></el-table-column>
                <el-table-column
                    label="Stock"
                    prop="drNumber"
                ></el-table-column>
                <el-table-column label="Unit" width="100" prop="drUnit"></el-table-column>
                <el-table-column label="Unit Price" width="150" prop="drPrice"></el-table-column>
                <el-table-column
                    width="300"
                    label="Publisher"
                    prop="drPublisher"
                ></el-table-column>
                <el-table-column label="Actions" width="290" fixed="right">
                    <template slot-scope="scope">
                        <el-button
                            style="font-size: 18px"
                            type="success"
                            @click="modifyDialog(scope.row.drId)"
                        > Edit</el-button>
                        <el-button
                            style="font-size: 18px"
                            type="danger"
                            @click="deleteDialog(scope.row.drId)"
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

        <!-- Add drug dialog -->
        <el-dialog title="Add Drug" :visible.sync="addFormVisible">
            <el-form :model="addForm" :rules="rules" ref="ruleForm">
                <el-form-item label="ID" prop="drId" label-width="120px">
                    <el-input v-model.number="addForm.drId"></el-input>
                </el-form-item>
                <el-form-item label="Name" prop="drName" label-width="120px">
                    <el-input v-model="addForm.drName"></el-input>
                </el-form-item>
                <el-form-item label="Quantity" prop="drNumber" label-width="120px">
                    <el-input-number
                        v-model="addForm.drNumber"
                        :min="0"
                        :max="1000"
                    ></el-input-number>
                </el-form-item>
                <el-form-item label="Unit" prop="drUnit" label-width="120px">
                    <el-radio v-model="addForm.drUnit" label="Box">Box</el-radio>
                    <el-radio v-model="addForm.drUnit" label="Bag">Bag</el-radio>
                    <el-radio v-model="addForm.drUnit" label="Dose">Dose</el-radio>
                </el-form-item>
                <el-form-item label="Unit Price" prop="drPrice" label-width="120px">
                    <el-input v-model="addForm.drPrice"></el-input>
                </el-form-item>
                <el-form-item
                    label="Publisher"
                    prop="drPublisher"
                    label-width="120px"
                >
                    <el-input v-model="addForm.drPublisher"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="addFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="addDrug('ruleForm')"
                    style="font-size: 18px;"> Confirm</el-button
                >
            </div>
        </el-dialog>

        <!-- Edit drug dialog -->
        <el-dialog title="Edit Drug" :visible.sync="modifyFormVisible">
            <el-form :model="modifyForm" :rules="rules" ref="ruleForm">
                <el-form-item label="ID" prop="drId" label-width="120px">
                    <el-input
                        v-model.number="modifyForm.drId"
                        disabled
                    ></el-input>
                </el-form-item>
                <el-form-item label="Name" prop="drName" label-width="120px">
                    <el-input v-model="modifyForm.drName"></el-input>
                </el-form-item>
                <el-form-item label="Quantity" prop="drNumber" label-width="120px">
                    <el-input-number
                        v-model="modifyForm.drNumber"
                        :min="0"
                        :max="1000"
                    ></el-input-number>
                </el-form-item>
                <el-form-item label="Unit" prop="drUnit" label-width="120px">
                    <el-radio v-model="modifyForm.drUnit" label="Box"
                        >Box</el-radio
                    >
                    <el-radio v-model="modifyForm.drUnit" label="Bag"
                        >Bag</el-radio
                    >
                    <el-radio v-model="modifyForm.drUnit" label="Dose"
                        >Dose</el-radio
                    >
                </el-form-item>
                <el-form-item label="Unit Price" prop="drPrice" label-width="120px">
                    <el-input v-model="modifyForm.drPrice"></el-input>
                </el-form-item>
                <el-form-item
                    label="Publisher"
                    prop="drPublisher"
                    label-width="120px"
                >
                    <el-input v-model="modifyForm.drPublisher"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="modifyFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="modifyDrug('ruleForm')"
                    style="font-size: 18px;"> Confirm</el-button
                >
            </div>
        </el-dialog>
    </div>
</template>
<script>
import request from "@/utils/request.js";

export default {
    name: "DrugList",
    data() {
        return {
            pageNumber: 1,
            size: 8,
            query: "",
            drugData: [],
            total: 3,
            addFormVisible: false,
            addForm: {},
            rules: {
                drId: [
                    { required: true, message: "Please enter ID", trigger: "blur" },
                    {
                        type: "number",
                        message: "ID must be a number",
                        trigger: "blur",
                    },
                ],
                drName: [
                    { required: true, message: "Please enter name", trigger: "blur" },
                    {
                        min: 1,
                        max: 50,
                        message: "Name must be 1 to 50 characters",
                        trigger: "blur",
                    },
                ],
                drUnit: [
                    { required: true, message: "Please select unit", trigger: "blur" },
                ],
                drPrice: [
                    { required: true, message: "Please enter unit price", trigger: "blur" },
                ],
                drPublisher: [
                    {
                        required: true,
                        message: "Please enter publisher",
                        trigger: "blur",
                    },
                    {
                        min: 1,
                        max: 50,
                        message: "Publisher must be 1 to 50 characters",
                        trigger: "blur",
                    },
                ],
            },
            modifyFormVisible: false,
            modifyForm: {},
        };
    },
    methods: {
        // Submit edited drug
        modifyDrug(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/drug/modifyDrug", {
                            params: {
                                drId: this.modifyForm.drId,
                                drName: this.modifyForm.drName,
                                drNumber: this.modifyForm.drNumber,
                                drPrice: this.modifyForm.drPrice,
                                drUnit: this.modifyForm.drUnit,
                                drPublisher: this.modifyForm.drPublisher,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error("Failed to update!");
                            this.modifyFormVisible = false;
                            this.requestDrugs();
                            this.$message.success("Drug updated successfully!");
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
                .get("hospital/drug/findDrug", {
                    params: {
                        drId: id,
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
        // Delete drug
        deleteDrug(id) {
            request
                .get("hospital/drug/deleteDrug", {
                    params: {
                        drId: id,
                    },
                })
                .then((res) => {
                    this.requestDrugs();
                    console.log(res);
                });
        },
        // Delete dialog
        deleteDialog(id) {
            this.$confirm("Delete this drug?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    this.deleteDrug(id);
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
        addDrug(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/drug/addDrug", {
                            params: {
                                drId: this.addForm.drId,
                                drName: this.addForm.drName,
                                drNumber: this.addForm.drNumber,
                                drPrice: this.addForm.drPrice,
                                drUnit: this.addForm.drUnit,
                                drPublisher: this.addForm.drPublisher,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error(
                                    "Invalid or occupied ID!"
                                );
                            this.addFormVisible = false;
                            this.requestDrugs();
                            this.$message.success("Drug added successfully!");
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
            this.requestDrugs();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestDrugs();
        },
        // Load drug list
        requestDrugs() {
            request
                .get("hospital/drug/findAllDrugs", {
                    params: {
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
                    this.drugData = res.data.data.drugs;
                    this.total = res.data.data.total;
                    
                });
        },
    },
    created() {
        this.requestDrugs();
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
