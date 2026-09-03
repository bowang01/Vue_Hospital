<template>
    <div>
        <el-card>
            <!-- <span>Department clinic</span> -->
            <el-divider></el-divider>
            <div class="sectionIndex" style="font-size: 24px">
                <b> Internal Medicine</b>
            </div>
            <ul>
                <li v-for="inter in inters" :key="inter">
                    <el-button
                        style="margin: 5px"
                        @click="sectionClick(inter)"
                        >{{ inter }}</el-button
                    >
                </li>
            </ul>
            <el-divider></el-divider>
            <div class="sectionIndex" style="font-size: 24px">
                <b> Surgery</b>
            </div>
            <ul>
                <li v-for="out in outs" :key="out">
                    <el-button style="margin: 5px" @click="sectionClick(out)">{{
                        out
                    }}</el-button>
                </li>
            </ul>
            <el-divider></el-divider>
            <div class="sectionIndex" style="font-size: 24px">
                <b> Obstetrics & Gynecology</b>
            </div>
            <ul>
                <li v-for="woman in women" :key="woman">
                    <el-button
                        style="margin: 5px"
                        @click="sectionClick(woman)"
                        >{{ woman }}</el-button
                    >
                </li>
            </ul>
            <el-divider></el-divider>
            <div class="sectionIndex" style="font-size: 24px">
                <b> Pediatrics</b>
            </div>
            <ul>
                <li v-for="kid in kids" :key="kid">
                    <el-button style="margin: 5px" @click="sectionClick(kid)">{{
                        kid
                    }}</el-button>
                </li>
            </ul>
            <el-divider></el-divider>
            <div class="sectionIndex" style="font-size: 24px">
                <b> ENT & Sensory</b>
            </div>
            <ul>
                <li v-for="five in fives" :key="five">
                    <el-button
                        style="margin: 5px"
                        @click="sectionClick(five)"
                        >{{ five }}</el-button
                    >
                </li>
            </ul>
            <el-divider></el-divider>
            <div class="sectionIndex" style="font-size: 24px">
                <b> Traditional Chinese Medicine</b>
            </div>
            <ul>
                <li v-for="chinese in chineses" :key="chinese">
                    <el-button
                        style="margin: 5px"
                        @click="sectionClick(chinese)"
                        >{{ chinese }}</el-button
                    >
                </li>
            </ul>
            <el-divider></el-divider>
            <div class="sectionIndex" style="font-size: 24px">
                <b> Others</b>
            </div>
            <ul>
                <li v-for="orther in orthers" :key="orther">
                    <el-button
                        style="margin: 5px"
                        @click="sectionClick(orther)"
                        >{{ orther }}</el-button
                    >
                </li>
            </ul>
            <el-divider></el-divider>
        </el-card>
    </div>
</template>
<script>

export default {
    name: "SectionIndex",
    data() {
        return {
            inters: [
                "Neurology",
                "Respiratory & Critical Care",
                "Endocrinology",
                "Gastroenterology",
                "Cardiology",
                "Nephrology",
                "Fever Clinic",
            ],
            outs: [
                "Hand & Foot Surgery",
                "General Surgery",
                "Colorectal Surgery",
                "Neurosurgery",
                "Urology",
                "Orthopedics",
                "Burn & Plastic Surgery",
            ],
            women: ["Gynecology", "Obstetrics"],
            kids: ["Pediatrics", "Child Healthcare"],
            fives: ["ENT", "Ophthalmology", "Stomatology"],
            chineses: ["TCM"],
            orthers: ["Rehabilitation", "Emergency", "Dermatology", "Function Exam"],
        };
    },
    methods: {
        // Department click
        sectionClick(section) {
            this.$router.push({ path: "/arrangeDoctor?section=" + section });
        },
    },
    mounted() {
      
    }
};
</script>
<style scoped lang="scss">
ul li {
    display: inline;
}
.el-breadcrumb {
    margin: 8px;
}
</style>
