<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

require_once "config.php";

$sql = "SELECT * FROM employees ORDER BY id DESC";

$result = $conn->query($sql);

$employees = [];

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $employees[] = $row;
    }
}

echo json_encode([
    "success" => true,
    "data" => $employees
]);

$conn->close();

?>