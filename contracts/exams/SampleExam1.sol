// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract SampleExam1 {
    address owner;
    mapping(address => bool) didPass;
    uint256 endTime;

    constructor() {
        owner = msg.sender;
    }

    function startExam() external {
        require(msg.sender == owner, "Only owner can start exam");
        endTime = block.timestamp + 15 minutes;
    }

    /// @notice In this function, the student should register the solution to the exam.
    function registerSolution(uint256 rightNumber) external {
        require(block.timestamp < endTime, "Exam is not open");
        require(rightNumber == 42, "Wrong number");
        didPass[msg.sender] = true;
    }

    function didEveryonePass(address[] memory students) external view returns (string memory) {
        for (uint256 i = 0; i < students.length; i++) {
            if (!didPass[students[i]]) {
                return "No";
            }
        }
        return "Yes";
    }
}
