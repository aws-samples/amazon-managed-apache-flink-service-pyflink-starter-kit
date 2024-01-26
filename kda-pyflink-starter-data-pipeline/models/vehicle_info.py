from dataclasses import dataclass
from enum import Enum


@dataclass
class VehicleLapData:
    vehicle_id: str
    source: str
    flag_state: str
    lead_lap: int
    published_time: int
    sequence_id: int
    time: int
    server_process_time: int


@dataclass
class LocationData:
    speed: str
    track_id: str
    vehicle_id: str
    heading: str
    recent_completeness: str
    lap_fraction: str
    position_x: str
    position_y: str
    position_z: str
    latitude: str
    longitude: str
    sector_number: str
    distance_from_white_line: str
    lap_fraction_pos: str
    quaternion_w: str
    quaternion_x: str
    quaternion_y: str
    quaternion_z: str
    velocity_x: str
    velocity_y: str
    velocity_z: str
    velocity_mag: str
    traffic_index: str
    corner_radius: str
    lap: str
    last_pit_lap: str
    stint_number: str
    sector_bounds: str

@dataclass
class TelemetryData:
    datapoint_id: str
    vehicle_id: str
    name: str
    source: str
    time_join: int
    timestamp: int
    type: str
    value: float
    race_id: str
    series_id: str
    run_id: str
    run_type: str
    server_process_time: int
    vehicle: VehicleLapData
    location: LocationData


@dataclass
class SessionInfo:
    race_id: int
    series_id: int
    run_id: int
    run_type: str

@dataclass
class ResultData:
    datapoint_id: str
    vehicle_id: str
    name: str
    source: str
    type: str
    race_id: str
    series_id: str
    run_id: str
    run_type: str
    server_process_time: int
    entry_id: int
    no: int
    lap: int
    lead_lap: int
    lap_tm: int
    best_tm: int
    best_lap: int
    best_spd: float
    ps: int
    spd: float
    avg_spd: float
    diff_tm: int
    diff_lap: int
    gap_tm: int
    gap_lap: int
    delta_tm: int
    delta_lap: int
    status: str
    status_id: int
    ttl_tm: int


class DataType(Enum):
    STEERING = 1
    RPM = 2
