<template>
    <!-- Card -->
    <el-card>
        <!-- Search bar and add doctor -->
        <el-row type="flex">
            <el-col :span="8">
                <el-input v-model="query" placeholder="Search by name">
                    <el-button
                        slot="append"
                        style="font-size: 18px;"
                        @click="requestDoctors"
                    > Search</el-button>
                </el-input>
            </el-col>
            <el-col :span="4"></el-col>
            <el-col :span="4">
                <el-button type="primary" @click="addFormVisible = true"
                        style="font-size: 18px;"
                    > 
                    Add Doctor</el-button
                >
            </el-col>
            <el-col :span="4"></el-col>
            <!-- Import data -->
            <!-- <el-col :span="2">
                <el-upload
                    class="upload-demo"
                    action="doctor/uploadExcel"
                    accept=".xlsx,.xls "
                    :limit="1"
                    :show-file-list="false"
                    :on-progress="handleProgress"
                    :on-exceed="handleExceed"
                    :on-success="handleSuccess"
                    :on-error="handleError"
                    :file-list="fileList"
                >
                    <el-button size="small" type="success">Import</el-button>
                </el-upload>
            </el-col>

            <el-col :span="2">
                <el-button size="small" type="success" @click="exportDoctors"
                    >Export</el-button
                ></el-col
            > -->
        </el-row>
        <!-- Table -->
        <el-table :data="doctorData" stripe style="width: 100%" border>
            <el-table-column prop="dId" label="Account" width="100">
            </el-table-column>
            <el-table-column prop="dName" label="Name" width="100">
            </el-table-column>
            <el-table-column prop="dGender" label="Gender" width="90">
            </el-table-column>
            <el-table-column prop="dPost" label="Title" width="180">
            </el-table-column>
            <el-table-column prop="dSection" label="Department" width="180">
            </el-table-column>
            <el-table-column prop="dCard" label="ID Number">
            </el-table-column>
            <el-table-column prop="dPhone" label="Phone">
            </el-table-column>
            <el-table-column prop="dEmail" label="Email" width="170">
            </el-table-column>
            <el-table-column prop="dAvgStar" label="Rating / 5" width="100">
            </el-table-column>
            <el-table-column prop="dPrice" label="Fee (CNY)" width="100">
            </el-table-column>
            <el-table-column prop="dState" label="Status" width="100">
                <template slot-scope="scope">
                    <el-tag type="success" v-if="scope.row.dState === 1"
                        >On Duty</el-tag
                    >
                    <el-tag type="danger" v-else>Resigned</el-tag>
                </template>
            </el-table-column>
            <el-table-column label="Actions" width="260" fixed="right">
                <template slot-scope="scope">
                    <el-button
                        style="font-size: 18px;"
                        type="success"
                        @click="modifyDialog(scope.row.dId)"
                    > Edit</el-button>
                    <el-button
                        style="font-size: 18px;"
                        type="danger"
                        @click="deleteDialog(scope.row.dId)"
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
        <!-- Add doctor dialog -->
        <el-dialog title="Add Doctor" :visible.sync="addFormVisible">
            <el-form :model="addForm" :rules="rules" ref="ruleForm">
                <el-form-item label="Account" label-width="120px" prop="dId">
                    <el-input
                        v-model.number="addForm.dId"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Password" label-width="120px">
                    <el-input
                        v-model="addForm.dPassword"
                        autocomplete="off"
                        disabled
                    ></el-input>
                </el-form-item>
                <el-form-item label="Name" label-width="120px" prop="dName">
                    <el-input
                        v-model="addForm.dName"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Gender" label-width="120px">
                    <el-radio v-model="addForm.dGender" label="Male">Male</el-radio>
                    <el-radio v-model="addForm.dGender" label="Female">Female</el-radio>
                </el-form-item>
                <el-form-item label="Title" label-width="120px" prop="dPost">
                    <el-select v-model="addForm.dPost" placeholder="Please select title">
                        <el-option
                            v-for="post in posts"
                            :key="post"
                            :label="post"
                            :value="post"
                        >
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="Department" label-width="120px" prop="dSection">
                    <el-select
                        v-model="addForm.dSection"
                        filterable
                        placeholder="Please select department"
                    >
                        <el-option
                            v-for="section in sections"
                            :key="section"
                            :label="section"
                            :value="section"
                        >
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="ID Number" label-width="120px" prop="dCard">
                    <el-input
                        v-model="addForm.dCard"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Phone" label-width="120px" prop="dPhone">
                    <el-input
                        v-model="addForm.dPhone"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Email" label-width="120px" prop="dEmail">
                    <el-input
                        v-model="addForm.dEmail"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Fee" label-width="120px" prop="dPrice">
                    <el-input
                        v-model="addForm.dPrice"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item
                    label="Bio"
                    label-width="120px"
                    prop="dIntroduction"
                >
                    <el-input
                        type="textarea"
                        :rows="5"
                        placeholder="Please enter content"
                        v-model="addForm.dIntroduction"
                    >
                    </el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="addFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="addDoctor('ruleForm')"
                    style="font-size: 18px;"> Confirm</el-button
                >
            </div>
        </el-dialog>

        <!-- Edit doctor dialog -->
        <el-dialog title="Edit Doctor" :visible.sync="modifyFormVisible">
            <el-form :model="modifyForm" :rules="rules" ref="ruleForm">
                <el-form-item label="Account" label-width="120px" prop="dId">
                    <el-input
                        v-model.number="modifyForm.dId"
                        autocomplete="off"
                        disabled
                    ></el-input>
                </el-form-item>

                <el-form-item label="Name" label-width="120px" prop="dName">
                    <el-input
                        v-model="modifyForm.dName"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Gender" label-width="120px">
                    <el-radio v-model="modifyForm.dGender" label="Male"
                        >Male</el-radio
                    >
                    <el-radio v-model="modifyForm.dGender" label="Female"
                        >Female</el-radio
                    >
                </el-form-item>
                <el-form-item label="Title" label-width="120px" prop="dPost">
                    <el-select
                        v-model="modifyForm.dPost"
                        placeholder="Please select title"
                    >
                        <el-option
                            v-for="post in posts"
                            :key="post"
                            :label="post"
                            :value="post"
                        >
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="Department" label-width="120px" prop="dSection">
                    <el-select
                        v-model="modifyForm.dSection"
                        filterable
                        placeholder="Please select department"
                    >
                        <el-option
                            v-for="section in sections"
                            :key="section"
                            :label="section"
                            :value="section"
                        >
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="ID Number" label-width="120px" prop="dCard">
                    <el-input
                        v-model="modifyForm.dCard"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Phone" label-width="120px" prop="dPhone">
                    <el-input
                        v-model="modifyForm.dPhone"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Email" label-width="120px" prop="dEmail">
                    <el-input
                        v-model="modifyForm.dEmail"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item label="Fee" label-width="120px" prop="dPrice">
                    <el-input
                        v-model="modifyForm.dPrice"
                        autocomplete="off"
                    ></el-input>
                </el-form-item>
                <el-form-item
                    label="Bio"
                    label-width="120px"
                    prop="dIntroduction"
                >
                    <el-input
                        type="textarea"
                        :rows="5"
                        placeholder="Please enter content"
                        v-model="modifyForm.dIntroduction"
                    >
                    </el-input>
                </el-form-item>
                <el-form-item label="Status" label-width="120px" prop="dState">
                    <el-input
                        v-model="modifyForm.dState"
                        autocomplete="off"
                        disabled
                    ></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="modifyFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
                <el-button type="primary" @click="modifyDoctor('ruleForm')"
                    style="font-size: 18px;"> Confirm</el-button
                >
            </div>
        </el-dialog>
    </el-card>
</template>
<script>
import request from "@/utils/request.js";

export default {
    name: "DoctorList",
    data() {
        var validateMoblie = (rule, value, callback) => {
            if (value === undefined) {
                callback(new Error("Please enter phone number"));
            } else {
                let reg =
                    /^1(3[0-9]|4[5,7]|5[0,1,2,3,5,6,7,8,9]|6[2,5,6,7]|7[0,1,7,8]|8[0-9]|9[1,8,9])\d{8}$/;
                if (!reg.test(value)) {
                    callback(new Error("Please enter a valid phone number"));
                }
                callback();
            }
        };
        var validateCard = (rule, value, callback) => {
            if (value === undefined) {
                callback(new Error("Please enter ID number"));
            } else {
                let reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
                if (!reg.test(value)) {
                    callback(new Error("Please enter a valid ID number"));
                }
                callback();
            }
        };
        return {
            // File upload
            fileList: [],
            pageNumber: 1,
            size: 8,
            query: "",
            doctorData: [],
            total: 3,
            addFormVisible: false,
            addForm: {
                dPassword: 123456,
                dGender: "Male",
            },
            posts: ["Chief Physician", "Associate Chief Physician", "Attending Physician"],
            sections: [
                "Neurology",
                "Endocrinology",
                "Respiratory & Critical Care",
                "Gastroenterology",
                "Cardiology",
                "Fever Clinic",
                "Hand & Foot Surgery",
                "General Surgery",
                "Colorectal Surgery",
                "Neurosurgery",
                "Orthopedics",
                "Burn & Plastic Surgery",
                "Gynecology",
                "Obstetrics",
                "Pediatrics",
                "ENT",
                "Ophthalmology",
                "TCM",
                "Emergency",
                "Dermatology",
                "Stomatology",
            ],
            rules: {
                dId: [
                    { required: true, message: "Please enter account", trigger: "blur" },
                    {
                        type: "number",
                        message: "Account must be a number",
                        trigger: "blur",
                    },
                ],
                dName: [
                    { required: true, message: "Please enter name", trigger: "blur" },
                    {
                        min: 2,
                        max: 5,
                        message: "Name must be 2 to 5 characters",
                        trigger: "blur",
                    },
                ],
                dPost: [
                    { required: true, message: "Please select title", trigger: "blur" },
                ],
                dSection: [
                    {
                        required: true,
                        message: "Please select department",
                        trigger: "blur",
                    },
                ],
                dEmail: [
                    { required: true, message: "Please enter email", trigger: "blur" },
                    {
                        type: "email",
                        message: "Please enter a valid email address",
                        trigger: ["blur", "change"],
                    },
                ],
                dPrice: [
                    {
                        required: true,
                        message: "Please enter fee",
                        trigger: "blur",
                    },
                ],
                dPhone: [{ validator: validateMoblie }],
                dCard: [{ validator: validateCard }],
                dIntroduction: [
                    {
                        required: true,
                        message: "Please enter bio",
                        trigger: "blur",
                    },
                ],
            },
            modifyFormVisible: false,
            modifyForm: {},
        };
    },
    methods: {
        // Export doctor data
        exportDoctors() {
            window.location.href = "/hospital/doctor/downloadExcel";
        },
        // File upload
        handleProgress() {
            this.$message.warning("File is being parsed!");
        },
        // File upload success hook
        handleSuccess() {
            this.$message.success("Data imported successfully!");
            this.requestDoctors();
        },
        handleError() {
            //this.$message.error("Data import failed!");
            this.$message.success("Data imported successfully!");
            this.requestDoctors();
        },
        handleExceed() {
            this.$message.warning("Only 1 file can be selected");
        },
        // Submit edited doctor
        modifyDoctor(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/admin/modifyDoctor", {
                            params: {
                                dId: this.modifyForm.dId,
                                dGender: this.modifyForm.dGender,
                                dName: this.modifyForm.dName,
                                dPost: this.modifyForm.dPost,
                                dSection: this.modifyForm.dSection,
                                dPhone: this.modifyForm.dPhone,
                                dEmail: this.modifyForm.dEmail,
                                dCard: this.modifyForm.dCard,
                                dPrice: this.modifyForm.dPrice,
                                dIntroduction: this.modifyForm.dIntroduction,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error("Failed to update!");
                            this.modifyFormVisible = false;
                            this.requestDoctors();
                            this.$message.success("Doctor updated successfully!");
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
                .get("hospital/admin/findDoctor", {
                    params: {
                        dId: id,
                    },
                })
                .then((res) => {
                    if (res.data.status !== 200)
                        this.$message.error("Failed to load data");
                    this.modifyForm = res.data.data;
                    this.modifyFormVisible = true;
                    console.log(res);
                });
        },
        // Delete doctor
        deleteDoctor(id) {
            request
                .get("hospital/admin/deleteDoctor", {
                    params: {
                        dId: id,
                    },
                })
                .then((res) => {
                    this.requestDoctors();
                    console.log(res);
                });
        },
        // Delete dialog
        deleteDialog(id) {
            this.$confirm("Delete this doctor?", "Notice", {
                confirmButtonText: "Confirm",
                cancelButtonText: "Cancel",
                type: "warning",
            })
                .then(() => {
                    this.deleteDoctor(id);
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
        // Add doctor
        addDoctor(formName) {
        
            
            if (!/^\d+$/.test(this.addForm.dId)) {
                this.$message.error("Invalid account: digits only, max 9 characters.");
                return;
            }
            if ((this.addForm.dId + "").length > 9) {
                this.$message.error(
                    "Account cannot exceed 9 digits!"
                );
                return
            }
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    request
                        .get("hospital/admin/addDoctor", {
                            params: {
                                dId: this.addForm.dId,
                                dGender: this.addForm.dGender,
                                dPassword: this.addForm.dPassword,
                                dName: this.addForm.dName,
                                dPost: this.addForm.dPost,
                                dSection: this.addForm.dSection,
                                dPhone: this.addForm.dPhone,
                                dEmail: this.addForm.dEmail,
                                dCard: this.addForm.dCard,
                                dPrice: this.addForm.dPrice,
                                dIntroduction: this.addForm.dIntroduction,
                                doctor: this.addForm,
                            },
                        })
                        .then((res) => {
                            if (res.data.status !== 200)
                                return this.$message.error(
                                    "Invalid or occupied account!"
                                );
                            this.addFormVisible = false;
                            this.requestDoctors();
                            this.$message.success("Doctor added successfully!");
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
            this.requestDoctors();
        },
        // Triggered when page number changes
        handleCurrentChange(num) {
            console.log(num);
            this.pageNumber = num;
            this.requestDoctors();
        },
        // Load doctor list
        requestDoctors() {
            request
                .get("hospital/admin/findAllDoctors", {
                    params: {
                        pageNumber: this.pageNumber,
                        size: this.size,
                        query: this.query,
                    },
                })
                .then((res) => {
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
<style scoped lang="scss">
.el-table {
    margin-top: 20px;
    margin-bottom: 20px;
}
.el-form {
    margin-top: 0;
}
</style>
