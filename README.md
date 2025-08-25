# Community Health Worker Program Coordination System

A comprehensive blockchain-based system for coordinating community health worker programs, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides a decentralized platform for managing community health worker programs, including worker certification, patient care coordination, health education delivery, outcome tracking, and resource allocation.

## System Architecture

The system consists of five interconnected smart contracts:

### 1. Worker Management Contract (`worker-management.clar`)
- Worker registration and profile management
- Training completion tracking
- Certification verification and renewal
- Performance metrics and ratings

### 2. Patient Care Contract (`patient-care.clar`)
- Patient registration and profile management
- Care plan creation and management
- Worker-patient assignment system
- Care delivery tracking and documentation

### 3. Health Education Contract (`health-education.clar`)
- Educational program creation and management
- Session scheduling and delivery tracking
- Participant enrollment and attendance
- Educational outcome measurement

### 4. Outcome Tracking Contract (`outcome-tracking.clar`)
- Health outcome data collection
- Program effectiveness measurement
- Statistical analysis and reporting
- Quality improvement tracking

### 5. Resource Allocation Contract (`resource-allocation.clar`)
- Funding distribution management
- Resource request and approval system
- Budget tracking and reporting
- Performance-based allocation algorithms

## Key Features

- **Decentralized Governance**: Community-driven decision making
- **Transparent Operations**: All activities recorded on blockchain
- **Performance-Based Incentives**: Rewards tied to measurable outcomes
- **Data Privacy**: Patient data protection with controlled access
- **Scalable Architecture**: Supports multiple health programs
- **Audit Trail**: Complete history of all transactions and changes

## Data Types

### Worker Profile
- Worker ID (unique identifier)
- Personal information (name, contact, location)
- Certification status and expiry dates
- Training completion records
- Performance metrics and ratings

### Patient Profile
- Patient ID (unique identifier)
- Basic demographics (age, gender, location)
- Health conditions and risk factors
- Care plan assignments
- Treatment history and outcomes

### Health Program
- Program ID and metadata
- Target population and objectives
- Educational content and materials
- Delivery schedule and methods
- Success metrics and KPIs

## Smart Contract Functions

### Worker Management
- `register-worker`: Register new community health worker
- `update-certification`: Update worker certification status
- `assign-training`: Assign training modules to workers
- `rate-worker`: Submit performance ratings

### Patient Care
- `register-patient`: Register new patient in system
- `create-care-plan`: Develop personalized care plan
- `assign-worker`: Assign worker to patient
- `record-visit`: Document care delivery visits

### Health Education
- `create-program`: Launch new health education program
- `schedule-session`: Schedule educational sessions
- `record-attendance`: Track participant attendance
- `measure-outcomes`: Collect educational outcomes

### Outcome Tracking
- `record-health-data`: Submit health outcome data
- `calculate-metrics`: Compute program effectiveness
- `generate-report`: Create performance reports
- `set-targets`: Define outcome targets

### Resource Allocation
- `allocate-funds`: Distribute program funding
- `request-resources`: Submit resource requests
- `approve-allocation`: Approve resource distribution
- `track-utilization`: Monitor resource usage

## Getting Started

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

3. Deploy contracts:
   \`\`\`bash
   clarinet deploy
   \`\`\`

## Testing

The system includes comprehensive tests using Vitest covering:
- Contract deployment and initialization
- Worker registration and management
- Patient care coordination
- Health education delivery
- Outcome measurement
- Resource allocation

## Security Considerations

- Access control mechanisms for sensitive operations
- Data validation and sanitization
- Protection against common smart contract vulnerabilities
- Privacy-preserving patient data handling

## Contributing

Please read the PR-DETAILS.md file for contribution guidelines and development workflow.

## License

This project is licensed under the MIT License.
