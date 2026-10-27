"""
Enterprise AIOps: Telemetry Incident Analyzer & Remediation Orchestrator
Performs statistical anomaly detection on cloud telemetry and triggers self-healing runbooks.
Author: Avinash Mishra (Principal Cloud & DevSecOps Enterprise Architect)
"""

import sys
import json
import logging
from typing import List, Dict, Any

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("AIOps-Analyzer")

class TelemetryAnomalyDetector:
    def __init__(self, z_score_threshold: float = 3.0):
        self.z_score_threshold = z_score_threshold

    def calculate_z_scores(self, values: List[float]) -> List[float]:
        """Calculates Z-score deviation for historical telemetry data points."""
        if len(values) < 3:
            return [0.0] * len(values)
        
        mean = sum(values) / len(values)
        variance = sum((x - mean) ** 2 for x in values) / len(values)
        std_dev = variance ** 0.5

        if std_dev == 0:
            return [0.0] * len(values)

        return [(x - mean) / std_dev for x in values]

    def evaluate_incident(self, metric_name: str, telemetry_series: List[float]) -> Dict[str, Any]:
        """Evaluates whether the latest telemetry point exceeds the anomalous deviation threshold."""
        z_scores = self.calculate_z_scores(telemetry_series)
        latest_score = z_scores[-1] if z_scores else 0.0
        latest_value = telemetry_series[-1] if telemetry_series else 0.0

        is_anomaly = abs(latest_score) >= self.z_score_threshold

        result = {
            "metric": metric_name,
            "latest_value": latest_value,
            "z_score": round(latest_score, 2),
            "is_anomaly": is_anomaly,
            "severity": "CRITICAL" if abs(latest_score) > 4.0 else ("HIGH" if is_anomaly else "NORMAL"),
            "suggested_action": "TRIGGER_SELF_HEALING_RUNBOOK" if is_anomaly else "NONE"
        }

        if is_anomaly:
            logger.warning(f"🚨 Anomaly Detected on {metric_name}! Z-Score: {latest_score:.2f} | Value: {latest_value}")
        else:
            logger.info(f"✅ Metric {metric_name} operating within normal baselines.")

        return result

if __name__ == "__main__":
    detector = TelemetryAnomalyDetector(z_score_threshold=3.0)
    
    # Example simulated telemetry: Memory utilization % over 10 intervals
    sample_telemetry = [42.1, 43.5, 41.8, 44.0, 42.9, 43.1, 45.2, 44.8, 43.9, 98.6]
    
    evaluation = detector.evaluate_incident("AppService_Memory_Percentage", sample_telemetry)
    print(json.dumps(evaluation, indent=2))

