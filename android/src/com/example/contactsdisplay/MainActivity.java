package com.example.newapp;

import android.os.Bundle;
import android.widget.Toast;
import android.content.Context;
import android.content.pm.PackageManager;
import android.Manifest;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.provider.ContactsContract;
import android.database.Cursor;
import org.qtproject.qt.android.bindings.QtActivity;
import java.util.ArrayList;
import java.util.List;
import android.content.ContentValues;
import android.net.Uri;
import android.content.ContentUris;

public class MainActivity extends QtActivity {

    private static final String TAG = "MainActivity";
    private static final int MY_PERMISSIONS_REQUEST_READ_CONTACTS = 1;
    private static final int MY_PERMISSIONS_REQUEST_WRITE_CONTACTS = 2;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public void checkContactPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(MainActivity.this,
                    new String[]{Manifest.permission.READ_CONTACTS}, MY_PERMISSIONS_REQUEST_READ_CONTACTS);
        }
    }

    public void checkEditContactPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_CONTACTS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(MainActivity.this,
                    new String[]{Manifest.permission.WRITE_CONTACTS}, MY_PERMISSIONS_REQUEST_WRITE_CONTACTS);
        }
    }

    public List<String> fetchContacts() {
        List<String> contactList = new ArrayList<>();
        Cursor cursor = null;

        // Check for permission before accessing contacts
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) == PackageManager.PERMISSION_GRANTED) {
            cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                    null, null, null, null);

            if (cursor != null && cursor.moveToFirst()) {
                do {
                    String contactId = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID));
                    String name = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
                    String phoneNumber = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
                    contactList.add("ID: " + contactId + ", Name: " + name + ", Phone: " + phoneNumber);
                } while (cursor.moveToNext());
            }
        }
        if (cursor != null) {
            cursor.close();
        }
        return contactList;
    }

    public void addContact(String name, String phone) {
        ContentValues values = new ContentValues();
        Uri rawContactUri = getContentResolver().insert(ContactsContract.RawContacts.CONTENT_URI, values);
        long rawContactId = ContentUris.parseId(rawContactUri);

        // Insert phone number
        values.clear();
        values.put(ContactsContract.Data.RAW_CONTACT_ID, rawContactId);
        values.put(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
        values.put(ContactsContract.CommonDataKinds.Phone.NUMBER, phone);
        values.put(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE);
        getContentResolver().insert(ContactsContract.Data.CONTENT_URI, values);

        // Insert name
        values.clear();
        values.put(ContactsContract.Data.RAW_CONTACT_ID, rawContactId);
        values.put(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE);
        values.put(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, name);
        getContentResolver().insert(ContactsContract.Data.CONTENT_URI, values);

        showToast("Contact Added.");
    }

    public List<String> editContact(String contactId, String newName, String newPhone) {
        List<String> contactList = new ArrayList<>();
        Cursor cursor = getContentResolver().query(
                ContactsContract.Data.CONTENT_URI,
                new String[]{
                        ContactsContract.Data.RAW_CONTACT_ID,
                        ContactsContract.Data.MIMETYPE,
                        ContactsContract.CommonDataKinds.Phone.NUMBER,
                        ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME
                },
                ContactsContract.Data.CONTACT_ID + " = ?",
                new String[]{contactId},
                null
        );

        if (cursor != null && cursor.moveToFirst()) {
            // The contact exists, now update its details

            // Get the RawContactId for updating the phone number and name
            String rawContactId = cursor.getString(cursor.getColumnIndex(ContactsContract.Data.RAW_CONTACT_ID));
            String currentPhone = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
            String currentName = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME));

            // Start with the phone number update
            ContentValues values = new ContentValues();
            boolean isUpdated = false;

            // If the phone number is different, update it
            if (!currentPhone.equals(newPhone)) {
                values.put(ContactsContract.CommonDataKinds.Phone.NUMBER, newPhone);
                getContentResolver().update(
                        ContactsContract.Data.CONTENT_URI,
                        values,
                        ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " +
                                ContactsContract.Data.MIMETYPE + " = ?",
                        new String[]{rawContactId, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE}
                );
                isUpdated = true;
            }

            // Now update the name if it's different
            values.clear();
            if (!currentName.equals(newName)) {
                values.put(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, newName);
                getContentResolver().update(
                        ContactsContract.Data.CONTENT_URI,
                        values,
                        ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " +
                                ContactsContract.Data.MIMETYPE + " = ?",
                        new String[]{rawContactId, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE}
                );
                isUpdated = true;
            }

            if (isUpdated) {
                contactList.add("ID: " + contactId + ", Name: " + newName + ", Phone: " + newPhone);
                showToast("Contact Updated.");
            } else {
                showToast("No changes made to contact.");
            }
        } else {
            showToast("Contact not found.");
        }

        if (cursor != null) {
            cursor.close();
        }
        return  contactList;
    }

    public void deleteContact(String contactId) {
        // Query the Data table to find the RawContactId based on the provided contactId
        Cursor cursor = getContentResolver().query(
                ContactsContract.Data.CONTENT_URI,
                new String[]{ContactsContract.Data.RAW_CONTACT_ID},
                ContactsContract.Data.CONTACT_ID + " = ?",
                new String[]{contactId},
                null
        );

        if (cursor != null && cursor.moveToFirst()) {
            // Retrieve the RawContactId
            String rawContactId = cursor.getString(cursor.getColumnIndex(ContactsContract.Data.RAW_CONTACT_ID));

            // Delete the contact using the RawContactId
            int rowsDeleted = getContentResolver().delete(
                    ContactsContract.RawContacts.CONTENT_URI,
                    ContactsContract.RawContacts._ID + " = ?",
                    new String[]{rawContactId}
            );

            if (rowsDeleted > 0) {
                showToast("Contact deleted.");
            } else {
                showToast("Failed to delete contact.");
            }
        } else {
            showToast("Contact not found.");
        }

        if (cursor != null) {
            cursor.close();
        }
    }


    public void showToast(final String message) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(MainActivity.this, message, Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode == MY_PERMISSIONS_REQUEST_READ_CONTACTS) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted
            } else {
                showToast("Permission denied. Can't access contacts.");
            }
        }

        if (requestCode == MY_PERMISSIONS_REQUEST_WRITE_CONTACTS) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted
            } else {
                showToast("Permission denied. Can't edit contacts.");
            }
        }
    }
}
