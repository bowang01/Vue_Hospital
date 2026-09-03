<template>
  <div>
    <el-card>
      <el-row :gutter="12">
        <el-col :span="8">
          <div class="field-label">Appointment No.</div>
          <el-input
            disabled
            v-model="oId"
            class="orderInput"
          ></el-input>
        </el-col>
        <el-col :span="8">
          <div class="field-label">Patient Account</div>
          <el-input
            disabled
            v-model="pId"
            class="orderInput"
          ></el-input>
        </el-col>
        <el-col :span="8">
          <div class="field-label">Patient Name</div>
          <el-input
            disabled
            v-model="pName"
            class="orderInput"
          ></el-input>
        </el-col>
      </el-row>
      <el-row :gutter="12">
        <el-col :span="8">
          <div class="field-label">Gender</div>
          <el-input
            disabled
            v-model="pGender"
            class="orderInput"
          ></el-input>
        </el-col>
        <el-col :span="8">
          <div class="field-label">Contact</div>
          <el-input
            disabled
            v-model="pPhone"
            class="orderInput"
          ></el-input>
        </el-col>
        <el-col :span="8">
          <div class="field-label">Doctor Name</div>
          <el-input
            disabled
            v-model="dName"
            class="orderInput"
          ></el-input>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="24" class="order-actions">
          <el-button type="success" @click="submitClick"><i class="iconfont icon-r-yes"></i> Submit</el-button>
          <el-button type="warning" @click="openReason"><i class="iconfont icon-r-paper"></i> Write Diagnosis</el-button>
        </el-col>
      </el-row>
      <!-- Drug table -->
      <el-row>
        <el-col :span="12">
          <el-input
            v-model="queryDrug"
            placeholder="Search by name"
            class="drugInput"
          >
            <el-button
              slot="append"
              icon="el-icon-search"
              @click="requestDrug"
            ></el-button>
          </el-input>
          <el-table :data="drugData" stripe border>
            <el-table-column label="ID" prop="drId"></el-table-column>
            <el-table-column label="Name" prop="drName"></el-table-column>
            <el-table-column label="Stock" prop="drNumber"></el-table-column>
            <el-table-column label="Unit" prop="drUnit"></el-table-column>
            <el-table-column label="Unit Price" prop="drPrice"></el-table-column>
            <el-table-column label="Actions" width="140" fixed="right">
              <template slot-scope="scope">
                <el-button
                  type="success"
                  style="font-size: 14px;"
                  @click="addDrug(scope.row.drId)"
                  >
                  <i class="iconfont icon-r-add" style="font-size: 16px;"></i> 
                  Add</el-button
                >
              </template>
            </el-table-column>
          </el-table>
          <!-- Pagination -->
          <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            background
            layout="total, sizes, prev, pager, next"
            :total="total"
            :page-size="size"
            :page-sizes="[1, 2, 4, 8, 16]"
          >
          </el-pagination>
          <el-row></el-row>
        </el-col>
        <!-- Selected drugs on the right -->
        <el-col :span="12" class="drugRigth">
          <el-table stripe border :data="drugBuyData" class="rigthTable">
            <el-table-column label="ID" prop="drId"></el-table-column>
            <el-table-column label="Name" prop="drName"></el-table-column>
            <el-table-column label="Unit Price" prop="drPrice"></el-table-column>
            <el-table-column label="Quantity" prop="drNum"></el-table-column>
            <el-table-column label="Subtotal" prop="drSum"></el-table-column>
            <el-table-column label="Actions" width="140" fixed="right">
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  
                  style="font-size: 14px;"
                  icon="iconfont icon-r-delete"
                  @click="deleteDrug(scope.row.drId)"
                  > Remove</el-button
                >
              </template>
            </el-table-column>
          </el-table>
          <el-tag>Total: {{ drugTotalPrice }} CNY</el-tag>
        </el-col>
      </el-row>
      <!-- Exam items -->
      <el-row>
        <el-col :span="12">
          <el-input
            v-model="queryCheck"
            placeholder="Search by name"
            class="drugInput"
          >
            <el-button
              slot="append"
              icon="el-icon-search"
              @click="requestCheck"
            ></el-button>
          </el-input>
          <el-table stripe border :data="checkData">
            <el-table-column label="ID" prop="chId"></el-table-column>
            <el-table-column label="Item" prop="chName"></el-table-column>
            <el-table-column label="Price" prop="chPrice"></el-table-column>
            <el-table-column label="Actions" width="140" fixed="right">
              <template slot-scope="scope">
                <el-button
                  type="success"
                  style="font-size: 14px;"
                  icon="iconfont icon-r-add"
                  @click="addCheck(scope.row.chId)"
                  > Add</el-button
                >
              </template>
            </el-table-column>
          </el-table>
          <!-- Pagination -->
          <el-pagination
            @size-change="checkSizeChange"
            @current-change="checkCurrentChange"
            background
            layout="total, prev, pager, next"
            :total="checkTotal"
            :page-size="checkSize"
          >
          </el-pagination>
        </el-col>
        <!-- Selected exams on the right -->
        <el-col :span="12" class="drugRigth">
          <el-table stripe border class="rigthTable" :data="checkBuyData">
            <el-table-column label="ID" prop="chId"></el-table-column>
            <el-table-column label="Item" prop="chName"></el-table-column>
            <el-table-column label="Price" prop="chPrice"></el-table-column>
            <el-table-column label="Actions" width="120" fixed="right">
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  style="font-size: 14px;"
                  icon="iconfont icon-r-delete"
                  @click="deleteCheck(scope.row.chId)"
                  > Remove</el-button
                >
              </template>
            </el-table-column>
          </el-table>
          <el-tag>Total: {{ checkTotalPrice }} CNY</el-tag>
        </el-col>
      </el-row>
    </el-card>

    <!-- Diagnosis dialog -->
    <el-dialog title="Write Diagnosis" :visible.sync="reasonFormVisible">
      <el-input
        type="textarea"
        :rows="8"
        placeholder="Please enter content"
        v-model="reason"
      >
      </el-input>
      <div slot="footer" class="dialog-footer">
        <el-button @click="reasonFormVisible = false" style="font-size: 18px;"> Cancel</el-button>
        <el-button type="primary" @click="holdReason">Save</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import jwtDecode from "jwt-decode";
import { getToken } from "@/utils/storage.js";
import request from "@/utils/request.js";

export default {
  name: "dealOrder",
  data() {
    return {
      oId: 1,
      pId: 1,
      dId: 0,
      pName: "aa",
      pGender: "as",
      pPhone: "asd",
      dName: "",
      drugData: [],
      size: 4,
      pageNumber: 1,
      total: 3,
      queryDrug: "",
      drugBuyData: [],
      drugTotalPrice: 0,
      // Diagnosis
      reason: "",
      // Exam table data
      checkData: [],
      queryCheck: "",
      checkTotal: 3,
      checkSize: 4,
      checkPageNumber: 1,
      checkTotalPrice: 0,
      checkBuyData: [],
      // Diagnosis dialog visibility
      reasonFormVisible: false,
    };
  },
  methods: {
    // Reduce drug stock by id
    reduceDrugNumber(drId, usedNumber) {
      request
        .get("hospital/drug/reduceDrugNumber", {
          params: {
            drId: drId,
            usedNumber: usedNumber,
          },
        })
        .then((res) => {
          if (res.data.status !== 200) {
            this.$message.error("Insufficient drug stock!!");
          }
        });
    },
    // Submit button
    submitClick() {
      for (let i = 0; i < this.drugBuyData.length; i++) {
        this.reduceDrugNumber(
          this.drugBuyData[i].drId,
          this.drugBuyData[i].drNum
        );
      }
      let data = {
        oId: this.dataPackage().oId,
        pId: this.pId,
        dId: this.dId,
        oRecord: this.dataPackage().oRecord,
        oDrug: this.dataPackage().oDrug,
        oCheck: this.dataPackage().oCheck,
        oTotalPrice: this.dataPackage().oTotalPrice,
      };
      request
        .post("hospital/order/updateOrder", data)
        .then((res) => {
          if (res.data.status !== 200) {
            this.$message.error("Request failed");
            return;
          }
          this.$message.success("Submitted successfully! Please ask the patient to log in and pay.");
          this.$router.push("/orderToday");
          console.log(res.data);
        })
        .catch((err) => {
          console.error(err);
        });
    },
    // Package data
    dataPackage() {
      let oDrug = "";
      let oCheck = "";
      let oTotalPrice = 0;
      let oId = this.oId;
      let oRecord = this.reason;
      for (let i = 0; i < this.drugBuyData.length; i++) {
        oDrug +=
          this.drugBuyData[i].drName +
          "*" +
          this.drugBuyData[i].drPrice +
          "(CNY)*" +
          this.drugBuyData[i].drNum +
          " ";
      }
      for (let i = 0; i < this.checkBuyData.length; i++) {
        oCheck +=
          this.checkBuyData[i].chName +
          "*" +
          this.checkBuyData[i].chPrice +
          "(CNY) ";
      }
      oCheck += " Exam total" + this.checkTotalPrice + "CNY ";
      oDrug += " Drug total" + this.drugTotalPrice + "CNY ";
      oTotalPrice = this.checkTotalPrice + this.drugTotalPrice;
      return { oId, oRecord, oDrug, oCheck, oTotalPrice };
    },
    // Save diagnosis
    holdReason() {
      this.reasonFormVisible = false;
      this.$message.success("Saved successfully!");
    },
    // Open diagnosis dialog
    openReason() {
      this.reasonFormVisible = true;
    },
    // Remove exam from selected list
    deleteCheck(chId) {
      for (let i = 0; i < this.checkBuyData.length; i++) {
        if (this.checkBuyData[i].chId === chId) {
          this.checkTotalPrice -= this.checkBuyData[i].chPrice; // Exam price total
          this.checkBuyData.splice(i, 1); // Remove the element at index i
        }
      }
    },
    // Add exam to selected list
    addCheck(chId) {
      request
        .get("hospital/check/findCheck", {
          params: {
            chId: chId,
          },
        })
        .then((res) => {
          if (res.data.status != 200) return this.$message.error("Failed to load data");
          // Backend returns an object, table binds an array
          this.checkBuyData.push({
            chId: res.data.data.chId,
            chPrice: res.data.data.chPrice,
            chName: res.data.data.chName,
          });
          this.checkTotalPrice += res.data.data.chPrice; // Exam price total
          console.log(res.data.data);
        });
    },
    // Triggered when exam page size changes
    checkSizeChange(size) {
      this.checkSize = size;
      this.requestCheck();
    },
    // Triggered when exam page number changes
    checkCurrentChange(num) {
      this.checkPageNumber = num;
      this.requestCheck();
    },
    // Request exam items
    requestCheck() {
      request
        .get("hospital/check/findAllChecks", {
          params: {
            size: this.checkSize,
            pageNumber: this.checkPageNumber,
            query: this.queryCheck,
          },
        })
        .then((res) => {
          
          if (res.data.status != 200) this.$message.error("Failed to load data");
          this.checkData = res.data.data.checks;
          this.checkTotal = res.data.data.total;
          console.log(res);
        });
    },
    /**
     * This logic is complex and error-prone
     */
    // Remove drug from selected list
    deleteDrug(drId) {
      for (let i = 0; i < this.drugBuyData.length; i++) {
        if (this.drugBuyData[i].drId === drId) {
          for (let j = 0; j < this.drugData.length; j++) {
            if (this.drugData[j].drId === drId) this.drugData[j].drNumber += 1;
          }
          this.drugBuyData[i].drNum -= 1;
          this.drugBuyData[i].drSum =
            this.drugBuyData[i].drPrice * this.drugBuyData[i].drNum;
          this.drugTotalPrice -= this.drugBuyData[i].drPrice; // Drug price total
          if (this.drugBuyData[i].drNum === 0) this.drugBuyData.splice(i, 1); // Remove the element at index i
        }
      }
    },
    // Add drug to selected list
    addDrug(drId) {
      request
        .get("hospital/drug/findDrug", {
          params: {
            drId: drId,
          },
        })
        .then((res) => {
          if (res.data.status != 200) return this.$message.error("Failed to load data");
          // Backend returns an object, table binds an array
          for (let i = 0; i < this.drugBuyData.length; i++) {
            if (this.drugBuyData[i].drId === res.data.data.drId) {
              for (let j = 0; j < this.drugData.length; j++) {
                if (
                  this.drugData[j].drId === res.data.data.drId &&
                  this.drugData[j].drNumber > 0
                ) {
                  this.drugData[j].drNumber -= 1;
                  this.drugBuyData[i].drNum += 1;
                  this.drugBuyData[i].drSum =
                    this.drugBuyData[i].drPrice * this.drugBuyData[i].drNum;
                  this.drugTotalPrice += this.drugBuyData[i].drPrice; // Drug price total
                  //return;
                }
              }
              return;
            }
          }
          for (let j = 0; j < this.drugData.length; j++) {
            if (
              this.drugData[j].drId === res.data.data.drId &&
              this.drugData[j].drNumber <= 0
            )
              return;
          }
          this.drugBuyData.push({
            drId: res.data.data.drId,
            drPrice: res.data.data.drPrice,
            drName: res.data.data.drName,
            drNum: 1,
            drSum: res.data.data.drPrice,
          });
          for (let j = 0; j < this.drugData.length; j++) {
            if (this.drugData[j].drId === res.data.data.drId)
              this.drugData[j].drNumber -= 1;
          }
          this.drugTotalPrice += res.data.data.drPrice; // Drug price total

          console.log(res.data.data);
        });
    },
    // Triggered when drug page size changes
    handleSizeChange(size) {
      this.size = size;
      this.requestDrug();
    },
    // Triggered when drug page number changes
    handleCurrentChange(num) {
      this.pageNumber = num;
      this.requestDrug();
    },

    // Get drug list
    requestDrug() {
      request
        .get("hospital/drug/findAllDrugs", {
          params: {
            size: this.size,
            pageNumber: this.pageNumber,
            query: this.queryDrug,
          },
        })
        .then((res) => {
          if (res.data.status != 200) this.$message.error("Failed to load data");
          this.drugData = res.data.data.drugs;
          this.total = res.data.data.total;

          console.log(res);
        });
    },
    // Get patient data
    requestPatient() {
      request
        .get("hospital/doctor/findPatientById", {
          params: {
            pId: this.pId,
          },
        })
        .then((res) => {
          console.log(res);
          if (res.data.status != 200) this.$message.error("Failed to load data");
          this.pName = res.data.data.pName;
          this.pGender = res.data.data.pGender;
          this.pPhone = res.data.data.pPhone;
        });
    },
    // Decode token
    tokenDecode(token) {
      if (token !== null) return jwtDecode(token);
    },
  },
  created() {
    this.dName = this.tokenDecode(getToken()).dName;
    this.dId = this.tokenDecode(getToken()).dId;
    this.oId = this.$route.query.oId;
    this.pId = this.$route.query.pId;
    this.requestPatient();
    this.requestDrug();
    this.requestCheck();
  },
};
</script>
<style lang="scss">
// Center text
.drugRigth {
  text-align: center;
}
.el-tag {
  margin: 8px;
}
.rigthTable {
  margin-top: 56px;
  margin-left: 8px;
}
.drugInput {
  margin-top: 8px;
  margin-bottom: 8px;
}
.el-row {
  margin: 5px;
}
.orderInput {
  width: 100%;
}
.field-label {
  margin-bottom: 6px;
  font-size: 13px;
  color: #606266;
}
.order-actions {
  margin-top: 8px;
}
.el-pagination {
  margin: 8px;
}
</style>
