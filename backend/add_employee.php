<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require_once "config.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    echo json_encode([
        "success" => false,
        "message" => "Only POST method is allowed"
    ]);
    exit;
}

$input = json_decode(file_get_contents("php://input"), true);

if (!$input) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid JSON data"
    ]);
    exit;
}

$name = trim($input["name"] ?? "");
$designation = trim($input["designation"] ?? "");
$joiningDate = trim($input["joining_date"] ?? "");
$isActive = isset($input["is_active"]) ? (int)$input["is_active"] : 1;

if ($name === "" || $designation === "" || $joiningDate === "") {
    echo json_encode([
        "success" => false,
        "message" => "Name, designation and joining date are required"
    ]);
    exit;
}

/*
 * First insert employee without employee_id.
 * Database generates the numeric ID automatically.
 */
$stmt = $conn->prepare(
    "INSERT INTO employees
    (name, designation, joining_date, is_active)
    VALUES (?, ?, ?, ?)"
);

$stmt->bind_param(
    "sssi",
    $name,
    $designation,
    $joiningDate,
    $isActive
);

if (!$stmt->execute()) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to add employee"
    ]);
    exit;
}

$databaseId = $stmt->insert_id;

/*
 * Generate Employee ID
 * Example: 1 -> EMP001
 *          2 -> EMP002
 */
$employeeId = "EMP" . str_pad($databaseId, 3, "0", STR_PAD_LEFT);

$updateStmt = $conn->prepare(
    "UPDATE employees SET employee_id = ? WHERE id = ?"
);

$updateStmt->bind_param(
    "si",
    $employeeId,
    $databaseId
);

if (!$updateStmt->execute()) {
    echo json_encode([
        "success" => false,
        "message" => "Employee created but ID generation failed"
    ]);
    exit;
}

echo json_encode([
    "success" => true,
    "message" => "Employee added successfully",
    "data" => [
        "id" => $databaseId,
        "employee_id" => $employeeId,
        "name" => $name,
        "designation" => $designation,
        "joining_date" => $joiningDate,
        "is_active" => $isActive
    ]
]);

$stmt->close();
$updateStmt->close();
$conn->close();

?>