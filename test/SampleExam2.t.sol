// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {Solarray} from "solarray/Solarray.sol";
import "contracts/exams/SampleExam2.sol";

// Mock SolutionContract for testing purposes with correct implementation
contract MockSolutionContract is SolutionContract {
    function returnTimestamp() external view returns (uint256) {
        return block.timestamp;
    }
}

// Mock SolutionContract with incorrect implementation
contract WrongSolutionContract is SolutionContract {
    function returnTimestamp() external view returns (uint256) {
        return block.timestamp + 1; // incorrect timestamp
    }
}

// Absolutely Wrong Implementation
contract AbsolutelyWrongContract {
    function wrongFunction() external view returns (uint256) {
        return block.timestamp; // incorrect timestamp
    }
}

contract SampleExam2Test is Test {
    SampleExam2 exam;
    MockSolutionContract mockSolution;
    WrongSolutionContract wrongSolution;
    AbsolutelyWrongContract absolutelyWrongContract;

    function setUp() public {
        vm.warp(1);
        exam = new SampleExam2();
        mockSolution = new MockSolutionContract();
        wrongSolution = new WrongSolutionContract();
    }

    function test_cannot_register_before_start() public {
        vm.startPrank(address(1));
        vm.expectRevert("Exam is not open");
        exam.registerSolution(address(mockSolution));
    }

    function test_can_register_after_start() public {
        exam.startExam();
        vm.startPrank(address(1));
        exam.registerSolution(address(mockSolution));
    }

    function test_only_owner_can_start_exam() public {
        vm.startPrank(address(2));
        vm.expectRevert("Only owner can start exam");
        exam.startExam();
    }

    function test_cannot_register_same_contract_twice() public {
        exam.startExam();
        vm.startPrank(address(1));
        exam.registerSolution(address(mockSolution));
        vm.expectRevert("Contract already registered");
        exam.registerSolution(address(mockSolution));
    }

    function test_register_with_wrong_contract() public {
        exam.startExam();
        vm.startPrank(address(1));
        vm.expectRevert("Wrong time");
        exam.registerSolution(address(wrongSolution));
    }

    function test_three_students_register_correctly() public {
        exam.startExam();

        vm.startPrank(address(1));
        exam.registerSolution(address(mockSolution));
        vm.stopPrank();

        vm.startPrank(address(2));
        exam.registerSolution(address(new MockSolutionContract()));
        vm.stopPrank();

        vm.startPrank(address(3));
        exam.registerSolution(address(new MockSolutionContract()));
        assertEq(exam.didEveryonePass(Solarray.addresses(address(1), address(2), address(3))), "Yes");
    }

    function test_three_students_register_incorrectly() public {
        exam.startExam();
        vm.prank(address(1));
        exam.registerSolution(address(mockSolution));
        // address(2) does not register
        vm.prank(address(3));
        exam.registerSolution(address(new MockSolutionContract()));
        assertEq(exam.didEveryonePass(Solarray.addresses(address(1), address(2), address(3))), "No");
    }

    function test_register_with_absolutely_wrong_contract() public {
        absolutelyWrongContract = new AbsolutelyWrongContract();
        exam.startExam();
        vm.startPrank(address(1));
        vm.expectRevert(); // Expecting revert because the contract doesn't implement SolutionContract interface
        exam.registerSolution(address(absolutelyWrongContract));
    }

    function test_cannot_register_twice_same_student_different_contract() public {
        exam.startExam();
        vm.startPrank(address(1));
        exam.registerSolution(address(new MockSolutionContract()));

        vm.expectRevert("Already passed");
        exam.registerSolution(address(mockSolution));
    }

    function test_cannot_register_after_exam_ended() public {
        exam.startExam();
        vm.roll(31 minutes); // Move the time forward by 31 minutes, so the 30-minute exam duration is exceeded
        vm.warp(31 minutes);
        vm.startPrank(address(1));
        vm.expectRevert("Exam is not open");
        exam.registerSolution(address(mockSolution));
    }
}
