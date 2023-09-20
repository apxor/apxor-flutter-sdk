package com.apxor.flutter;

import static com.apxor.androidsdk.core.Constants.INTERNAL_EVENTS;

import com.apxor.androidsdk.core.models.BaseApxorEvent;

import org.json.JSONObject;

public final class Event extends BaseApxorEvent {
    private final String name;
    private final JSONObject data;

    public Event(String name, JSONObject data) {
        this.name = name;
        this.data = data;
    }

    @Override
    public JSONObject getJSONData() {
        return data;
    }

    @Override
    public String getEventType() {
        return INTERNAL_EVENTS;
    }

    @Override
    public String getEventName() {
        return name;
    }
}
