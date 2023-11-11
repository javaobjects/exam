package com.wzz.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wzz.entity.ExamRecord;
import com.wzz.entity.User;
import com.wzz.service.impl.*;
import com.wzz.vo.CommonResult;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @Date 2020/11/7 19:44
 * @created by xianxian
 */
@RestController
@RequestMapping(value = "/student")
@Slf4j
@Api(tags = "学生权限相关的接口")
public class StudentController {

    @Autowired
    private ExamServiceImpl examService;

    @Autowired
    private UserServiceImpl userService;

    @Autowired
    private QuestionServiceImpl questionService;

    @Autowired
    private ExamQuestionServiceImpl examQuestionService;

    @Autowired
    private ExamRecordServiceImpl examRecordService;

    @Autowired
    private QuestionBankServiceImpl questionBankService;

    @Autowired
    private AnswerServiceImpl answerService;

    @GetMapping("/getMyGrade")
    @ApiOperation("获取个人成绩(分页 根据考试名查询)")
    public CommonResult<List<ExamRecord>> getMyGrade(String username, Integer pageNo, Integer pageSize,
                                                     @RequestParam(required = false) Integer examId) {
        User user = userService.getOne(new QueryWrapper<User>().eq("username", username));
        //参数一是当前页，参数二是每页个数
        IPage<ExamRecord> examRecordPage = new Page<>(pageNo, pageSize);
        //查询条件(可选)
        QueryWrapper<ExamRecord> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", user.getId());
        if (examId != null) wrapper.eq("exam_id", examId);

        IPage<ExamRecord> page = examRecordService.page(examRecordPage, wrapper);
        List<ExamRecord> records = page.getRecords();
        return new CommonResult<>(200, "查询成绩成功", records);
    }
}
