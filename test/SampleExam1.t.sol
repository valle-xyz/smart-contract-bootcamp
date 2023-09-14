// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {Solarray} from "solarray/Solarray.sol";
import "contracts/exams/SampleExam1.sol";

contract SampleExamTest is Test {
    SampleExam1 exam;

    function setUp() public {
        exam = new SampleExam1();
    }

    function test_cannot_register_before_start() public {
        vm.startPrank(address(1));
        vm.expectRevert("Exam is not open");
        exam.registerSolution(42);
    }

    function test_can_register_after_start() public {
        exam.startExam();
        vm.startPrank(address(1));
        exam.registerSolution(42);
    }

    function test_only_owner_can_start_exam() public {
        vm.startPrank(address(2));
        vm.expectRevert("Only owner can start exam");
        exam.startExam();
    }

    function test_three_students_register_correctly() public {
        exam.startExam();
        vm.prank(address(1));
        exam.registerSolution(42);
        vm.prank(address(2));
        exam.registerSolution(42);
        vm.prank(address(3));
        exam.registerSolution(42);
        assertEq(exam.didEveryonePass(Solarray.addresses(address(1), address(2), address(3))), "Yes");
    }

    function test_three_students_register_incorrectly() public {
        exam.startExam();
        vm.prank(address(1));
        exam.registerSolution(42);
        // address(2) does not register
        vm.prank(address(3));
        exam.registerSolution(42);
        assertEq(exam.didEveryonePass(Solarray.addresses(address(1), address(2), address(3))), "No");
    }
}
