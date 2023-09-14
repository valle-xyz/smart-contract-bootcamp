// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

interface SolutionContract {
    function returnTimestamp() external returns (uint256);
}

contract SampleExam2 {
    address owner;
    mapping(address => bool) didPass;
    mapping(address => bool) contractRegistered;
    uint256 endTime;

    constructor() {
        owner = msg.sender;
    }

    function startExam() external {
        require(msg.sender == owner, "Only owner can start exam");
        endTime = block.timestamp + 30 minutes;
    }

    /// @notice In this function, the student should register the solution to the exam.
    /// @dev The student should deploy a contract that implements the SolutionContract interface.
    /// The student should call the registerSolution function on this contract with the address of the deployed contract.
    /// The SolutionContract should implement a function 'returnTimestamp' that returns the current block timestamp.
    function registerSolution(address studentsContract) external {
        require(block.timestamp < endTime, "Exam is not open");
        require(!contractRegistered[studentsContract], "Contract already registered");
        require(!didPass[msg.sender], "Already passed");

        // Check if the solution contract implements the SolutionContract interface
        SolutionContract solution = SolutionContract(studentsContract);
        uint256 value = solution.returnTimestamp();
        require(value == block.timestamp, "Wrong time");

        // Register the contract
        contractRegistered[studentsContract] = true;

        // Mark student as passed
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
