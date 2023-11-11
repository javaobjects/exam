package com.wzz;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wzz.Util.RedisUtil;
import com.wzz.entity.*;
import com.wzz.service.impl.*;
import com.wzz.vo.CommonResult;
import com.wzz.vo.QuestionVo;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;

import java.io.Serializable;
import java.util.*;

@SpringBootTest
class ExamAdminApplicationTests {

    @Autowired
    private UserServiceImpl userService;

    @Autowired
    private QuestionServiceImpl questionService;

    @Autowired
    private QuestionBankServiceImpl questionBankService;

    @Autowired
    private ExamRecordServiceImpl examRecordService;

    @Autowired
    private AnswerServiceImpl answerService;

    @Test
    void contextLoads() {
//        String s = "[{'topMenuName':'控制台','icon':'el-icon-odometer'},{'topMenuName':'在线考试','topIcon':'el-icon-menu','submenu':[{'name':'在线考试','icon':'el-icon-s-promotion','url':''},{'name':'我的成绩','icon':'el-icon-trophy','url':''},{'name':'我的题库','icon':'el-icon-notebook-2','url':''}]},{'topMenuName':'考试管理','topIcon':'el-icon-bangzhu','submenu':[{'name':'题库管理','icon':'el-icon-aim','url':''},{'name':'试题管理','icon':'el-icon-news','url':''},{'name':'考试管理','icon':'el-icon-tickets','url':''},{'name':'阅卷管理','icon':'el-icon-view','url':''}]},{'topMenuName':'考试统计','topIcon':'el-icon-pie-chart','submenu':[{'name':'统计总览','icon':'el-icon-data-line','url':''},{'name':'部门统计','icon':'el-icon-data-analysis','url':''}]},{'topMenuName':'系统设置','topIcon':'el-icon-setting','submenu':[{'name':'角色管理','icon':'el-icon-s-custom','url':''},{'name':'用户管理','icon':'el-icon-user-solid','url':''}]}]";
//        s = s.replaceAll("'","\"");
//        System.out.println(s);
        IPage<User> userPage = new Page<>(2, 2);//参数一是当前页，参数二是每页个数
        userPage = userService.page(userPage, null);
        List<User> list = userPage.getRecords();
        for (User user : list) {
            System.out.println(user);
        }
    }

    @Autowired
    private RedisUtil redisUtil;

    @Test
    void testRedis() throws JsonProcessingException {
        User user = new User(1, 1, "wzz", "112", "1231", "121", 1, new Date());
        System.out.println(user);
        ObjectMapper mapper = new ObjectMapper();
        redisUtil.set("user:1", mapper.writeValueAsString(user), 60);
        System.out.println(mapper.readValue(redisUtil.get("user:1").toString(), User.class));
    }

    @Autowired
    private UserRoleServiceImpl userRoleService;

    @Test
    void t2() {
        System.out.println(redisUtil.get("userRoles"));
        List<UserRole> userRoles = userRoleService.list(new QueryWrapper<>());
        redisUtil.set("userRoles", userRoles);
    }

    @Test
    void t3() {
        QuestionBank bank = questionBankService.getById(1);
        //在题库中的(单选,多选,判断题)题目
        List<Question> questions = questionService.list(new QueryWrapper<Question>().like("qu_bank_name", bank.getBankName()).in("qu_type", "1,2,3"));
        //构造前端需要的vo对象
        List<QuestionVo> questionVos = new ArrayList<>();
        for (Question question : questions) {
            QuestionVo questionVo = new QuestionVo();

            questionVo.setQuestionId(question.getId());
            questionVo.setQuestionLevel(question.getLevel());
            if (question.getImage() != null && !question.getImage().equals("")) //防止没有图片对象
                questionVo.setImages(question.getImage().split(","));
            questionVo.setCreatePerson(question.getCreatePerson());
            questionVo.setAnalysis(question.getAnalysis());
            questionVo.setQuestionContent(question.getQuContent());
            questionVo.setQuestionType(question.getQuType());

            Answer answer = answerService.getOne(new QueryWrapper<Answer>().eq("question_id", question.getId()));
            //选项个数
            String[] options = answer.getAllOption().split(",");
            //构造答案对象
            QuestionVo.Answer[] handleAnswer = new QuestionVo.Answer[options.length];
            //字段处理
            for (int i = 0; i < options.length; i++) {
                QuestionVo.Answer answer1 = new QuestionVo.Answer();
                answer1.setAnswer(options[i]);
                answer1.setId(i);
                handleAnswer[i] = answer1;
            }
            if (question.getQuType() != 2) {//单选和判断
                int trueOption = Integer.parseInt(answer.getTrueOption());
                handleAnswer[trueOption].setIsTrue("true");
                handleAnswer[trueOption].setAnalysis(answer.getAnalysis());
            } else {//多选
                String[] trueOptions = answer.getTrueOption().split(",");
                for (String trueOption : trueOptions) {
                    handleAnswer[Integer.parseInt(trueOption)].setIsTrue("true");
                    handleAnswer[Integer.parseInt(trueOption)].setAnalysis(answer.getAnalysis());
                }
            }
            questionVo.setAnswer(handleAnswer);
            questionVos.add(questionVo);
        }
        System.out.println(questionVos);
    }

    @Autowired
    private ExamServiceImpl examService;

    @Test
    void t4() {
        List<Exam> exams = examService.list(new QueryWrapper<>());
        List<ExamRecord> examRecords = examRecordService.list(new QueryWrapper<ExamRecord>().isNotNull("total_score"));
        //考试的名称
        String[] examNames = new String[exams.size()];
        //考试通过率
        double[] passRates = new double[exams.size()];

        double total = 0;
        double pass = 0;
        for (int i = 0; i < exams.size(); i++) {
            examNames[i] = exams.get(i).getExamName();
            total = 0;
            pass = 0;
            for (ExamRecord examRecord : examRecords) {
                if (Objects.equals(examRecord.getExamId(), exams.get(i).getExamId())) {
                    total++;
                    if (examRecord.getTotalScore() >= exams.get(i).getPassScore()) pass++;
                }
            }
            passRates[i] = pass / total;
        }
        for (int i = 0; i < passRates.length; i++) {
            if (Double.isNaN(passRates[i])) passRates[i] = 0;
        }
        String res1 = Arrays.toString(examNames);
        String res2 = Arrays.toString(passRates);
        System.out.println(res1.substring(1, res1.length() - 1).replaceAll(" ", ""));
        System.out.println(res2.substring(1, res2.length() - 1).replaceAll(" ", ""));
    }

    @Test
    void t5() {
        List<Exam> exams = examService.list(new QueryWrapper<>());
        List<ExamRecord> examRecords = examRecordService.list(new QueryWrapper<ExamRecord>());
        //考试的名称
        String[] examNames = new String[exams.size()];
        //考试的考试次数
        String[] examNumbers = new String[exams.size()];

        int total = 0;
        int cur = 0;
        for (int i = 0; i < exams.size(); i++) {
            examNames[i] = exams.get(i).getExamName();
            total = 0;
            cur = 0;
            for (ExamRecord examRecord : examRecords) {
                total++;
                if (Objects.equals(examRecord.getExamId(), exams.get(i).getExamId())) {
                    cur++;
                }
            }
            examNumbers[i] = cur + "";
        }
        System.out.println(Arrays.toString(examNames));
        System.out.println(Arrays.toString(examNumbers));
    }
}
